#-*- coding: utf-8 -*-

module BirdStrike

  class Core

    def initialize
      Curses.init

      home_win = Curses::Window.new(0, 0, 0, 0)
      home_win.puts_title
#      @prompt = Prompt.new(home_win.maxy)

      sleep 1

      @@conf = FileIO.get_config
      keys   = FileIO.get_consumer_key_secret
      token  = FileIO.get_access_token

      if token.nil?  # Authorization Part
        home_win.print_center(Authorization.get_oauth_url keys, -4)
        begin
          pin   = home_win.prompt("pin").strip.to_i
          token = Authorization.get_oauth_token(pin)
        rescue => e
          home_win.print_center(e.message, -2)
          retry
        end
        FileIO.store_access_token token
      end
      Authorization.authorize(keys.merge token)
      @@stream_client = TweetStream::Client.new

      @timelines = [new_stream(home_win, :userstream)]

      Thread.new(@timelines){ |timelines|  # Input Processing
        timelines.each{|tl| tl.stream.run}
        loop do
          cmd = Curses.getch
          case cmd
          when 13 || Curses::KEY_ENTER  # Enter
            timelines.first.stop
            prompt = Prompt.new(home_win.maxy)
            tweet = prompt.get_input
            Twitter.update(tweet) unless tweet.nil?
            prompt.close
            timelines.first.start
            timelines.each(&:rewrite_timeline)
          end
        end
      }.join

      #[TwitterModule::Streaming.thread, InputLoop.thread].each(&:run)
    end

    def new_stream(window, method, *args)
      tl = Timeline.new(window)
      tl.stream = Thread.new {
        @@stream_client.send(method, *args, &tl.on_receipt)
      }
#      tl.stream.run
      return tl
    end

  end
end

at_exit {
  Curses.close_screen
}

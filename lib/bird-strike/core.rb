#-*- coding: utf-8 -*-

module BirdStrike

  class Core

    def initialize
      Curses.init

      @windows = [Curses::Window.new(0, 0, 0, 0)]
      @windows.first.puts_title

      sleep 1

      @@conf = FileIO.get_config
      keys   = FileIO.get_consumer_key_secret
      token  = FileIO.get_access_token

      # Authorization Part
      if token.nil?
        @windows.first.print_center(Authorization.get_oauth_url keys, -4)
        begin
          pin   = @windows.first.prompt("pin").strip.to_i
          token = Authorization.get_oauth_token(pin)
        rescue => e
          @windows.first.print_center(e.message, -2)
          retry
        end
        FileIO.store_access_token token
      end
      Authorization.authorize(keys.merge token)
      @@stream_client = TweetStream::Client.new

      @timelines = [new_stream(@windows.first, :userstream)]
      @a = 0
      # Input Processing
      Thread.new {
        # @timelines.first.window.print_center(Curses.stdscr.maxyx.to_s, 5)
        loop do
          refresh_windows
          cmd = Curses.getch
          case cmd
          when 13 || Curses::Key::ENTER  # Enter
            @timelines.first.stop
            prompt = Prompt.new(*Curses.stdscr.maxyx)
            tweet = prompt.get_input
            Twitter.update(tweet) unless tweet.nil?
            prompt.close
            @timelines.first.start
            @timelines.each(&:rewrite)
          end
        end
      }.join
    end

    def new_stream(window, method, *args)
      tl = Timeline.new(window)
      tl.stream = Thread.new {
        @@stream_client.send(method, *args, &tl.on_receipt)
      }
      tl.stream.run
      return tl
    end

    # Resize, Replace, Rewrite
    def refresh_windows
      Curses.close_screen
      Curses.init
      maxy, maxx = Curses.stdscr.maxyx
      x = 0
      maxx.split(@timelines.size).zip(@timelines) do |width, timeline|
        timeline.window.close
        timeline.window = Curses::Window.new(maxy, width, 0, x)
        timeline.rewrite
        x += width
      end
    end

  end
end

at_exit {
  Curses.close_screen
}

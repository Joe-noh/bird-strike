#-*- coding: utf-8 -*-

module BirdStrike

  class Core

    def initialize
      Ncurses.init

      @windows = [Ncurses::WINDOW.new(0, 0, 0, 0)]
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
      # Input Processing
      Thread.new {
        loop do
          cmd = Ncurses.getch
          case cmd
          when 13 || Ncurses::KEY_ENTER  # Enter
            @timelines.first.stop
            prompt = Prompt.new
            tweet = prompt.get_input
            Twitter.update(tweet) unless tweet.nil?
            prompt.close
            @timelines.first.start
            @timelines.each(&:rewrite)
          when Ncurses::KEY_RESIZE
            # refresh_window
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

    # Resize, Replace, Rewrite   FIXME! THIS METHOD DOESN'T WORK!
    def refresh_windows
      maxy, maxx = Ncurses.stdscr.getsize
      x = 0
      maxx.split(@timelines.size).zip(@timelines) do |width, timeline|
#        timeline.window.delete
#        timeline.window = Ncurses::WINDOW.new(maxy, width, 0, x)
        timeline.window.resize(maxy, width)
        timeline.rewrite
        x += width
      end
    end

  end
end

at_exit {
  Ncurses.endwin
}

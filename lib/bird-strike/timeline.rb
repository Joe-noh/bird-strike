module BirdStrike
  class Timeline
    attr_accessor :window

    @@writing = false
    @@stream_client = TweetStream::Client.instance

    def initialize(height, width, y, x, method = :userstream, *args)
      @tweets = Array.new
#      @window = Curses::Window.new(height, width, y, x)
      @stream = Thread.new {
        @@stream_client.send(method, *args, &on_receipt)
      }
      @stream.run
    end

    def on_receipt
      Proc.new do |tweet|
        @tweets.unshift tweet
        puts @tweet
#        renew unless @@writing
      end
    end

    def renew # too dirty, too complex
      @window.clear
      maxy, maxx = @window.maxyx
      y = x = 0
      @tweets.each do |tweet|
        name, text, rtby = tweet.name_text_rtby
        @window.mvaddstr(y, 0, name)
        indent = @window.curx
        text.each_char do |char|
          if  @window.curx >= maxx-2 || @window.cury >  y
            y += 1
            break if y >= maxy
            @window.mvaddstr(y, 0, " "*indent)
          end
          break if y >= maxy
          @window.addstr char
        end
        break if y >= maxy

        unless rtby.nil?
          x = @window.curx
          y += 1 if (x + rtby.length) > maxx
          break if y >= maxy
          @window.mvaddstr(y, @window.maxx-rtby.length, rtby)
        end
        y += 1
      end
      @window.refresh
    end

    def self.start_updating
      @@writing = false
    end

    def self.stop_updating
      @@writing = true
    end

  end
end

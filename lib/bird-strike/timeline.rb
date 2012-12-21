module BirdStrike
  class Timeline
    attr_accessor :window

    @@writing = false

    def initialize(height, width, y, x, method = :userstream, *args)
      @@colorizer rescue @@colorizer = Colorizer.new
      @@stream_client = TweetStream::Client.instance
      @tweets = Array.new
      @tweets = Twitter.home_timeline(:count => 40) if method == :userstream
      @window = Curses::Window.new(height, width, y, x)
      Thread.start {
        @@stream_client.send(method, *args, &on_receipt)
      }
    end

    def on_receipt
      Proc.new do |tweet|
        @tweets.unshift tweet
        renew unless @@writing
      end
    end

    def renew # too dirty, too complex
      @window.clear
      maxy, maxx = @window.maxyx
      y = x = 0
      @tweets.each do |tweet|
        break if y >= maxy
        name, text, rt_user = tweet.name_text_rtby
        @window.mvaddstr(y, 0, " ")
        @window.color_set(@@colorizer.color_of name)
        @window.addstr name
        @window.color_set(0)
        @window.addstr ": "
        indent = @window.curx
        text.separate_screen_name.each do |part|
          @window.color_set(@@colorizer.color_of part)
          part.each_char do |char|
            if  @window.curx >= maxx-2 || @window.cury >  y
              y += 1
              break if y >= maxy
              @window.mvaddstr(y, 0, " "*indent)
            end
            break if y >= maxy
            @window.addstr char
          end
          break if y >= maxy
        end

        unless rt_user.nil?
          rtby = " [Retweeted by #{rt_user}] "
          x = @window.curx
          y += 1 if (x + rtby.length) > maxx
          break if y >= maxy
          @window.mvaddstr(y, @window.maxx-rtby.length, " [Retweeted by ")
          @window.color_set(@@colorizer.color_of rt_user)
          @window.addstr rt_user
          @window.color_set(0)
          @window.addstr "] "
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

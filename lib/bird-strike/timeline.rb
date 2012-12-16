module BirdStrike
  class Timeline
    attr_accessor :stream, :window, :tweets

    @@writing = false

    def initialize(win)
      @window = win
      @tweets = Array.new
    end

    def on_receipt
      Proc.new do |tweet|
        @tweets.unshift tweet
        self.rewrite unless @@writing
      end
    end

    def rewrite # too dirty, too complex
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

    def start
      @@writing = false
    end

    def stop
      @@writing = true
    end

  end
end

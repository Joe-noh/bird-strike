module BirdStrike
  class Timeline
    attr_accessor :stream, :screen

    def initialize(win)
      @stream = nil
      @screen = win
      @tweets = Array.new
    end

    def on_receipt
      Proc.new do |tweet|
        @screen.addstr tweet.user.screen_name
        @screen.refresh
        @tweets.unshift tweet
        self.rewrite_timeline
      end
    end

    def rewrite_timeline # too dirty, too complex
      @screen.clear
      maxx = @screen.maxx
      maxy = @screen.maxy
      y = x = 0
      @tweets.each do |tweet|
        name, text, rtby = tweet.name_text_rtby
        rtby = rtby.rjust maxx unless rtby.nil?
#        @screen.mvaddstr(y, 0, ' '*maxx)
        @screen.setpos(y, 0)
        @screen.addstr(name)
        indent = @screen.curx
        text.each_char do |char|
          if  @screen.curx >= maxx-2 || @screen.cury >  y
            y += 1
            break if y >= maxy
            @screen.setpos(y, 0)
            @screen.addstr(" "*indent)
          end
          break if y >= maxy
          @screen.addstr char
        end
        break if y >= maxy
        y += 1
      end
      @screen.refresh
    end

  end
end

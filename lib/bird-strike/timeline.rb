module BirdStrike
  class Timeline
    attr_accessor :stream, :screen

    def initialize(win)
      @stream = nil
      @window = win
      @tweets = Array.new
    end

    def on_receipt
      Proc.new do |tweet|
        @window.addstr tweet.user.screen_name
        @window.refresh
        @tweets.unshift tweet
        self.rewrite_timeline
      end
    end

    def rewrite_timeline # too dirty, too complex
      @window.clear
      maxx, maxy = @window.maxxy
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
          if x + rtby.length <= maxx
            @window.addstr rtby
          else
            y += 1
            break if y >= maxy
            @window.mvaddstr(y, x, rtby)
          end
        end
        y += 1
      end
      @window.refresh
    end

    def print_center(str, y)
      # TODO : consider screen width and str.length
      x = (@window.maxx-str.length) / 2
      y =  @window.maxy-y + 1 if y < 0

      mvaddstr(y, x, str)
      @window.refresh
    end

    def prompt
      @@msg_scr.setpos(0, 0)
      @@msg_scr.refresh

      Curses.curs_set 1
      system("stty  echo")
      input = Readline.readline
      system("stty -echo")
      Curses.curs_set 0

      @@msg_scr.clear
      @@msg_scr.refresh

      return input
    end
  end
end

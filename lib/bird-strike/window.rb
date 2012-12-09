#-*- coding: utf-8 -*-

module BirdStrike
  class Window

    def initialize
      ncurses_init
      @timeline = TimeLine.new(:userstream)
      make_subwins
      rewrite
    end

    def rewrite
      x = Ncurses.getmaxx @@tl_scr
      y = Ncurses.getmaxy @@tl_scr
    end

    def self.add_tweet_status(status)
      @@tweets.unshift status
      self.writing?
      self.rewrite_timeline
    end

    def print_center(str, y)
      # TODO : consider screen width and str.length
      x = (Ncurses.getmaxx(@@tl_scr)-str.length) / 2
      y =  Ncurses.getmaxy(@@tl_scr)-y + 1 if y < 0

      @@tl_scr.mvaddstr(y, x, str)
      @@tl_scr.refresh
    end

    def puts_title
      title = Array.new
      title << "        11111111111111111111111        111111111111111111  1111111111"
      title << "  1111  1111111111111111111  11  1111  111111111111111111  1111111111"
      title << "  1111  111  11111111111111  11  111111111  1111111111  1  1111111111"
      title << "          11111111111111111  11          1    11111111111  11        "
      title << "  111111  1  1      1        1111111111  1  111      1  1  11  1111  "
      title << "  111111  1  1  11111  1111  11  111111  1  111  11111  1            "
      title << "  111111  1  1  11111  1111  11  111111  1  111  11111  1  11  111111"
      title << "          1  1  11111        11          1    1  11111  1  11        "
      width  = title.first.length
      height = title.length

      x = (Ncurses.getmaxx(@@tl_scr) - width )/2
      y = (Ncurses.getmaxy(@@tl_scr) - height)/2

      @@tl_scr.color_set(7, nil)
      title.each_with_index do |line, i|
        @@tl_scr.mvaddstr(y+i, x, line)
      end
      @@tl_scr.color_set(0, nil)
      @@tl_scr.move(y, x)
      title.each_with_index do |line, i|
        line.each_char.with_index do |char, j|
          @@tl_scr.mvaddstr(y+i, x+j, ' ') unless char == ' '
        end
      end
      @@tl_scr.refresh
    end

    def self.prompt
      @@msg_scr.move(0, 0)
      @@msg_scr.refresh

      Ncurses.curs_set 1
      system("stty  echo")
      input = Readline.readline
      system("stty -echo")
      Ncurses.curs_set 0

      @@msg_scr.clear
      @@msg_scr.refresh

      return input
    end

    def self.deprompt
      maxx = Ncurses.getmaxx(@@msg_scr)
      @@msg_scr.mvaddstr(1, 1, ' '*(maxx-2))
      @@msg_scr.move(1, 1)
      @@msg_scr.refresh
    end

    def self.rewrite_timeline # too dirty, too complex
      @@tl_scr.clear
      maxx = Ncurses.getmaxx(@@tl_scr)
      maxy = Ncurses.getmaxy(@@tl_scr)
      y = 0; x = 0
      @@tweets.each do |tweet|
        name, text, rtby = tweet.name_text_rtby
        rtby = rtby.rjust maxx unless rtby.nil?
        @@tl_scr.mvaddstr(y, 0, ' '*maxx)
        @@tl_scr.mvaddstr(y, 0, name)
        indent = Ncurses.getcurx(@@tl_scr)
        text.each_char do |char|
          if  Ncurses.getcurx(@@tl_scr) >= maxx-2 ||
              Ncurses.getcury(@@tl_scr) >  y
            y += 1
            break if y >= maxy
            @@tl_scr.move(y, 0)
            @@tl_scr.addstr " "*indent
          end
          break if y >= maxy
          @@tl_scr.addstr char
        end
        break if y >= maxy
        y += 1
      end
      @@tl_scr.refresh
    end

    private
    def ncurses_init
      Ncurses.setlocale(Ncurses::LC_ALL, "")
      Ncurses.initscr
      Ncurses.cbreak
      Ncurses.nonl
      Ncurses.echo
      Ncurses.curs_set 0

      Ncurses.start_color
      Ncurses.init_pair(1, Ncurses::COLOR_RED,     Ncurses::COLOR_BLACK)
      Ncurses.init_pair(2, Ncurses::COLOR_GREEN,   Ncurses::COLOR_BLACK)
      Ncurses.init_pair(3, Ncurses::COLOR_BLUE,    Ncurses::COLOR_BLACK)
      Ncurses.init_pair(4, Ncurses::COLOR_CYAN,    Ncurses::COLOR_BLACK)
      Ncurses.init_pair(5, Ncurses::COLOR_MAGENTA, Ncurses::COLOR_BLACK)
      Ncurses.init_pair(6, Ncurses::COLOR_YELLOW,  Ncurses::COLOR_BLACK)
      Ncurses.init_pair(7, Ncurses::COLOR_BLACK,   Ncurses::COLOR_CYAN )
    end

    def make_subwins
      cols, rows = get_max_cols_rows(Ncurses.stdscr)
      # Sub Window
      #  Ncurses::WINDOW.new(height, width, lefttopy, lefttopx)
      @tl_scr = Ncurses::WINDOW.new(rows-5, 0, 0, 0)

      @msg_scr = Ncurses::WINDOW.new(0, 0, 0, 0)
      @msg_scr.border(*"  ------".bytes)
      @msg_scr.intrflush false
      @msg_scr.keypad true
      @msg_scr.idlok true
      @msg_scr.scrollok true
    end

    def self.writing?
      x = Ncurses.getcurx(@@msg_scr)
      y = Ncurses.getcury(@@msg_scr)
      @@tl_scr.mvaddstr(0, 0, x.to_s)
      return x<=3 && y==1 ? false : true
    end

    def get_max_cols_rows(screen)
      return Ncurses.getmaxx(screen), Ncurses.getmaxy(screen)
    end

    def self.at_exit
      Ncurses.echo
      Ncurses.nocbreak
      Ncurses.nl
      Ncurses.endwin
    end

  end
end

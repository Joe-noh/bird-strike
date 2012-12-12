#-*- coding: utf-8 -*-

module BirdStrike
  class Window < Curses::Window
    @@initialized = false

    def initialize(a, b, c, d)
      curses_init unless @@initialized
      @win = super #Curses::Window.new(0, 0, 0, 0)
    end

#    def method_missing(method, *args)
#      @win.send(method, *args)
#    end

    def print_center(str, y)
      # TODO : consider screen width and str.length
      x = (@win.maxx-str.length) / 2
      y =  @win.maxy-y + 1 if y < 0

      mvaddstr(y, x, str)
      @win.refresh
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

      x = (@win.maxx - width )/2
      y = (@win.maxy - height)/2

      @win.color_set(7)
      @win.setpos(y, x)
      title.each_with_index do |line, i|
        line.each_char.with_index do |char, j|
          mvaddstr(y+i, x+j, ' ') if char == ' '
        end
      end
      @win.color_set(0)
      @win.refresh
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

    def mvaddstr(y, x, str)
      @win.setpos(y, x)
      @win.addstr str
    end

    private
    def curses_init
#      Curses.setlocale(Curses::LC_ALL, "") # necessary?
      Curses.init_screen
      Curses.cbreak
      Curses.nonl
      Curses.echo
      Curses.curs_set 0

      Curses.start_color
      Curses.init_pair(1, Curses::COLOR_RED,     Curses::COLOR_BLACK)
      Curses.init_pair(2, Curses::COLOR_GREEN,   Curses::COLOR_BLACK)
      Curses.init_pair(3, Curses::COLOR_BLUE,    Curses::COLOR_BLACK)
      Curses.init_pair(4, Curses::COLOR_CYAN,    Curses::COLOR_BLACK)
      Curses.init_pair(5, Curses::COLOR_MAGENTA, Curses::COLOR_BLACK)
      Curses.init_pair(6, Curses::COLOR_YELLOW,  Curses::COLOR_BLACK)
      Curses.init_pair(7, Curses::COLOR_BLACK,   Curses::COLOR_CYAN )
    end

    def self.writing?
      x = Curses.getcurx(@@msg_scr)
      y = Curses.getcury(@@msg_scr)
      @@tl_scr.mvaddstr(0, 0, x.to_s)
      return x<=3 && y==1 ? false : true
    end

    def get_max_cols_rows(screen)
      return screen.maxx, screen.maxy
    end

=begin
    def @win.at_exit
      Curses.echo
      Curses.nocbreak
      Curses.nl
      Curses.close_screen
    end
=end
  end
end

#-*- coding: utf-8 -*-

class String
  def width
    self.each_char.inject(0) do |sum, c|
      (c.ascii_only? ? 1 : 2 ) + sum
    end
  end
end

class Fixnum
  def split(n)
    return [self] if n <= 1
    width = self/n
    return Array.new(n-1, width) << (self - width*(n-1))
  end
end

module Twitter
  class Tweet
    def name_text_rtby
      if self.retweet?
        status = self.retweeted_status
        rt_by = "[Retweeted by #{self.from_user}]"
      else
        status = self
      end
      name = ' '+status.from_user+': '
      return name, CGI.unescapeHTML(status.text), rt_by
    end
  end
end

module Ncurses
  module_function

  def init
    Ncurses.initscr
    Ncurses.cbreak
    Ncurses.nonl
    Ncurses.noecho
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

  class WINDOW
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

      x = (self.getmaxx - width )/2
      y = (self.getmaxy - height)/2

      self.attrset(Ncurses.COLOR_PAIR 7)
      self.move(y, x)
      title.each_with_index do |line, i|
        line.each_char.with_index do |char, j|
          mvaddstr(y+i, x+j, ' ') if char == ' '
        end
      end
      self.attrset(Ncurses.COLOR_PAIR 0)
      self.refresh
    end

    def print_center(str, y)
      # TODO : consider screen width and str.length
      x = (self.getmaxx-str.length) / 2
      y =  self.getmaxy-y + 1 if y < 0

      self.mvaddstr(y, x, str)
      self.refresh
    end

#    def mvaddstr(y, x, str)
#      self.setpos(y, x)
#      self.addstr str
#    end

    def getsize
      return self.getmaxy, self.getmaxx
    end
  end
end

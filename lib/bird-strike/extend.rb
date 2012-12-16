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

module Curses
  module_function

  def init
    Curses.init_screen
    Curses.cbreak
    Curses.nonl
    Curses.noecho
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

  class Window
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

      x = (self.maxx - width )/2
      y = (self.maxy - height)/2

      self.color_set(7)
      self.setpos(y, x)
      title.each_with_index do |line, i|
        line.each_char.with_index do |char, j|
          mvaddstr(y+i, x+j, ' ') if char == ' '
        end
      end
      self.color_set(0)
      self.refresh
    end

    def print_center(str, y)
      # TODO : consider screen width and str.length
      x = (self.maxx-str.length) / 2
      y =  self.maxy-y + 1 if y < 0

      mvaddstr(y, x, str)
      self.refresh
    end

    def mvaddstr(y, x, str)
      self.setpos(y, x)
      self.addstr str
    end

    def maxyx
      return self.maxy, self.maxx
    end
  end
end

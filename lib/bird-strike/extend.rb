#-*- coding: utf-8 -*-

module Twitter
  class Tweet
    def name_text_rtby
      if self.retweet?
        status = self.retweeted_status
        rt_by = "[Retweeted by #{self.from_user}]"
      else
        status = self
      end
      return status.from_user, CGI.unescapeHTML(status.text), rt_by
    end
  end
end

module TweetStream
  class Client
    include Singleton
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
    def mvaddstr(y, x, str)
      self.setpos(y, x)
      self.addstr str
    end

    def maxyx
      return self.maxy, self.maxx
    end
  end
end

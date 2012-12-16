#-*- coding: utf-8 -*-

module BirdStrike
  class Prompt

    def initialize(y, x)
      @p_height = y
      @p_width = x
      @window = Curses::Window.new(2, @p_width, @p_height-2, 0)
      @window.setpos(0, 0)
      @window.addstr("-"*@p_width)
      @window.refresh
    end

    def get_input
      height = 5; buf = Array.new
      Curses.curs_set 1
      system("stty echo")
      while line = Readline.readline
        break if line.chomp.length == 0
        @window.setpos(@window.maxy, 0)
        buf << line
        rewrite_prompt(buf, height, "Press Enter to Confirm.")
        height += 1
      end
      system("stty -echo")
      Curses.curs_set 0
      return (buf.join.strip.length == 0) ? nil : buf.join
    end

    def close
      @window.clear
      @window.refresh
      @window.close
    end

    private
    def rewrite_prompt(buf, height, message)
#      get_parent_size
      @window.move(@p_height-height, 0)
      @window.resize(height, @p_width)
      @window.clear
      @window.mvaddstr(0, 0, "-"*@p_width)
      buf.each_with_index do |line, i|
        @window.mvaddstr(i+1, 1, line)
      end
      @window.mvaddstr(buf.size+1, 0, message.rjust(@p_width))
      @window.mvaddstr(buf.size+2, 0, "-"*@p_width)
      @window.refresh
    end

    def get_parent_size
      @p_height, @p_width = Curses.stdscr.maxyx
    end
  end
end

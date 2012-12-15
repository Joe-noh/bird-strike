#-*- coding: utf-8 -*-

module BirdStrike
  class Prompt

    def initialize(p_height)
      @p_height = Curses.stdscr.maxy
      @window = Curses::Window.new(2, 0, @p_height-2, 0)
      @window.setpos(0, 0)
      @window.addstr("-"*@window.maxx)
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
      maxx = @window.maxx
      @window.move(@p_height-height, 0)
      @window.resize(height, maxx)
      @window.clear
      @window.mvaddstr(0, 0, "-"*maxx)
      buf.each_with_index do |line, i|
        @window.mvaddstr(i+1, 1, line)
      end
      @window.mvaddstr(buf.size+1, 0, message.rjust(maxx))
      @window.mvaddstr(buf.size+2, 0, "-"*maxx)
      @window.refresh
    end
  end
end

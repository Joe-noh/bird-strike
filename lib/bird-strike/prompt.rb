#-*- coding: utf-8 -*-

module BirdStrike
  class Prompt

    def initialize
      @p_height, @p_width = Curses.stdscr.maxyx
    end

    def get_line(prompt_message)
      open_prompt
      while line = Readline.readline(prompt_message)
        if line.chomp.length == 0
          @window.clear
          @window.refresh
        else
          close_prompt
          return line
        end
      end
    end

    def get_input
      height = 5
      buf = Array.new
      open_prompt
      while line = Readline.readline
        break if line.chomp.length == 0
        @window.setpos(@window.maxy, 0)
        buf << line
        rewrite_prompt(buf, height, "Press Enter to Confirm.")
        height += 1
      end
      close_prompt
      return (buf.join.strip.length == 0) ? nil : buf.join
    end
    require "rainbow"
    private
    def open_prompt
      @window = Curses::Window.new(2, 0, @p_height-2, 0)
      @window.setpos(0, 0)

      @window.addstr("-"*@window.maxx)
      @window.refresh
      Curses.curs_set 1
      system("stty echo")
    end

    def close_prompt
      system("stty -echo")
      Curses.curs_set 0
      @window.clear
      @window.refresh
      @window.close
    end

    def rewrite_prompt(buf, height, message)
      @window.move(@p_height-height, 0)
      @window.resize(height, @_width)
      @window.clear
      @window.mvaddstr(0, 0, "-"*@p_width)
      buf.each_with_index do |line, i|
        @window.mvaddstr(i+1, 1, line)
      end
      @window.mvaddstr(buf.size+1, 0, message.rjust(@p_width))
      @window.mvaddstr(buf.size+2, 0, "-"*@p_width)
      @window.refresh
    end

  end
end

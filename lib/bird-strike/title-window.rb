
module BirdStrike
  class TitleWindow

    def initialize
      @window = Curses::Window.new(0, 0, 0, 0)
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

      x = (@window.maxx - width )/2
      y = (@window.maxy - height)/2

      @window.color_set(7)
      @window.setpos(y, x)
      title.each_with_index do |line, i|
        line.each_char.with_index do |char, j|
          @window.mvaddstr(y+i, x+j, ' ') if char == ' '
        end
      end
      @window.color_set(0)
      @window.refresh
    end

    def print_in_middle(str, y)
      # TODO : consider screen width and str.length
      x = (@window.maxx-str.length) / 2
      y =  @window.maxy-y + 1 if y < 0

      @window.mvaddstr(y, x, str)
      @window.refresh
    end

  end
end

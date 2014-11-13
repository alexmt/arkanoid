module Arkanoid
  class Canvas

    def initialize(width, height)
      @width = width
      @height = height
      @background_line = " " * @width
      clear
    end

    def clear
      @content = Array.new @height, @background_line
    end

    def draw(x, y, line)
      if y >=0 and @content.length > y
        @content[y] = @content[y][0..x] + line[0..@content[y].length - x]
      end
    end

    def content
      @content.join "\n"
    end

    def width
      @width
    end

    def height
      @height
    end
  end
end
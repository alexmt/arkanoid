require 'arkanoid/version'
require 'dispel'

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

  class Engine

    def initialize
      @objects = []
    end

    def start(manager)
      Dispel::Screen.open do |screen|
        canvas = Canvas.new screen.columns, screen.lines
        start = Time.now
        Dispel::Keyboard.output timeout: 0.01 do |key|
          next_start = Time.now
          delta = next_start - start
          start = next_start
          if key == :"Ctrl+c"
            break
          elsif
            manager.process_input key
          end
          manager.update_state delta, width: screen.columns, height: screen.lines
          render screen, canvas
        end
      end
    end

    def add_object(object)
      @objects << object
    end

    private

    def render(screen, canvas)
      canvas.clear
      @objects.each do |object|
        object.draw canvas
      end
      screen.draw canvas.content
    end
  end

  class Platform

    attr_accessor :speed

    def initialize(x = 0, width = 10)
      @x = x
      @width = width
    end

    def draw(canvas)
      canvas.draw @x, canvas.height - 1, "-" * @width
    end

    def move(delta)
      @x += delta * speed
    end
  end

  class Ball

    def initialize(x = 0, y = 0, speed_x = 0, speed_y = 0)
      @x = x
      @y = y
      @speed_x = speed_x
      @speed_y = speed_y
    end

    def draw(canvas)
      canvas.draw @x, @y, "0"
    end

    def move(delta)
      @x += @speed_x * delta
      @y += @speed_y * delta
    end

    def x
      @x
    end

    def y
      @y
    end

    def bounce_x
      @speed_x = -@speed_x
    end

    def bounce_y
      @speed_y = -@speed_y
    end

  end

  class Game

    def initialize
      @ball = Ball.new 10, 10, 20, 20
      @platform = Platform.new
    end

    def start
      engine = Engine.new
      engine.add_object(@ball)
      engine.add_object(@platform)
      engine.start self
    end

    def update_state(delta, options)
      @platform.move delta
      @ball.move delta
      @ball.bounce_x if options[:width] <= @ball.x or @ball.x <= 0
      @ball.bounce_y if options[:height] <= @ball.y or @ball.y <= 0
    end

    def process_input(key)
      case key
      when :left
        @platform.speed = -100
      when :right
        @platform.speed = 100
      when :timeout
        @platform.speed = 0
      end
    end
  end
end

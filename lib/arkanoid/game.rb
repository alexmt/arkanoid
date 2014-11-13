require 'arkanoid/engine'

module Arkanoid

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

    attr_reader :x, :y

    def draw(canvas)
      canvas.draw @x, @y, "0"
    end

    def move(delta)
      @x += @speed_x * delta
      @y += @speed_y * delta
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

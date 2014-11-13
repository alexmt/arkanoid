require 'arkanoid/engine'

module Arkanoid

  class Platform

    def initialize(x = 0, width = 10)
      @x = x
      @width = width
    end

    attr_accessor :speed
    attr_reader :x, :width

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
      @stop_requested = false
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
      if @ball.y <= 0
        @ball.bounce_y
      elsif options[:height] <= @ball.y
        if @ball.x >= @platform.width and @ball.x <= @platform.x + @platform.width
          @ball.bounce_y
        else
          @stop_requested = true
        end
      end
      !@stop_requested
    end

    def process_input(key)
      case key
      when :left
        @platform.speed = -100
      when :right
        @platform.speed = 100
      when :timeout
        @platform.speed = 0
      when :"Ctrl+c"
        @stop_requested = true
      end
    end
  end
end

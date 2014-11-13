require 'dispel'
require 'arkanoid/canvas'

module Arkanoid

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
end
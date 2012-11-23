require 'chingu'

class Game < Chingu::Window

	def initialize
		super(640,480,false)
		self.input = {esc: :exit}
		@player = Player.create
	end
end


class Player < Chingu::GameObject

	def setup
		@image = Gosu::Image["skepp.png"]
		@x, @y = 350, 400
		self.input = {
			holding_left: :left,
			holding_right: :right,
			holding_up: :up,
			holding_down: :down
		}
	end
	def left
		unless @x < 15
			@x -= 3.3
		end
	end
	def right
		unless @x > 625
			@x += 3.3
		end
	end
	def up
		unless @y < 100
			@y -= 2.5
		end
	end
	def down
		unless @y > 430
			@y += 2.5
		end
	end
end

Game.new.show
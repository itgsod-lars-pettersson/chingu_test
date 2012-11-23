require 'chingu'

class Game < Chingu::Window

	def initialize
		super(640,480,false)
		self.input = {esc: :exit}
		@background = Background.create
		@player = Player.create
	end
end

class Background < Chingu::GameObject
	def setup
		@image = Gosu::Image["bakgrund.png"]
		@x, @y = 320, 240
	end
end

class Player < Chingu::GameObject

	def setup
		@animation = Chingu::Animation.new(:file => "droid_44x60.bmp")
		@animation.frame_names = {:scan => 0..5, :left => 6..7, :right => 8..9 }
		@frame_name = :scan
		@x, @y = 350, 400
		@last_x, @last_y = @x, @y
		@last_direction = 1
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
		@frame_name = :left
		@last_direction = 0
	end
	def right
		unless @x > 625
			@x += 3.3
		end
		@frame_name = :right
		@last_direction = 1
	end
	def up
		unless @y < 60
			@y -= 2.5
		end
		if @last_direction == 0 then @frame_name = :left
		else @frame_name = :right
		end
	end
	def down
		unless @y > 445
			@y += 2.5
		end
		if @last_direction == 0 then @frame_name = :left
		else @frame_name = :right
		end
	end

	def update
		@image = @animation[@frame_name].next
		@frame_name = :scan if @x == @last_x && @y == @last_y
		@last_x, @last_y = @x, @y
	end
end

Game.new.show
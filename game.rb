require 'chingu'

class Game < Chingu::Window

	def initialize
		super(640,480,false)
		self.input = {esc: :exit}
		@background = Background.create
		@player = Player.create
	end

	def update
		super
	end
end

class Background < Chingu::GameObject
	def setup
		@image = Gosu::Image["bakgrund.png"]
		@x, @y = 320, 240
	end
end

class Player < Chingu::GameObject
	attr_reader :x, :y, :width, :height, :last_direction
	attr_writer :walk_modifier
	
	def setup
		@animation = Chingu::Animation.new(:file => "droid_44x60.bmp")
		@animation.frame_names = {:scan => 0..5, :left => 6..7, :right => 8..9 }
		@frame_name = :scan
		@width, @height = 22, 30
		@x, @y = 350, 400
		@last_x, @last_y = @x, @y
		@last_direction = 1
		@shoot_delay = 0
		@walk_modifier = 1
		self.input = {
			holding_left: :left,
			holding_right: :right,
			holding_up: :up,
			holding_down: :down,
			holding_space: :shoot
		}
	end
	def left
		unless @x < 15
			@x -= 3.3 * @walk_modifier
		end
		@frame_name = :left
		@last_direction = 0
	end
	def right
		unless @x > 625
			@x += 3.3 * @walk_modifier
		end
		@frame_name = :right
		@last_direction = 1
	end
	def up
		unless @y < 75
			@y -= 2.5 * @walk_modifier
		end
		if @last_direction == 0 then @frame_name = :left
		else @frame_name = :right
		end
	end
	def down
		unless @y > 445
			@y += 2.5 * @walk_modifier
		end
		if @last_direction == 0 then @frame_name = :left
		else @frame_name = :right
		end
	end
	def shoot
		if @shoot_delay > 10
			@shoot_delay = 0
			Laser.create(x: @x, y: @y, laser_direction: @last_direction)
		end
	end

	def update
		@shoot_delay += 1
		@image = @animation[@frame_name].next
		@frame_name = :scan if @x == @last_x && @y == @last_y
		@last_x, @last_y = @x, @y
		if @x > 330 && @x < 470
			if (@y > 70 && @y < 150) || (@y > 265 && @y < 430) then @walk_modifier = 0.35
			else @walk_modifier = 1
			end
		else @walk_modifier = 1
		end
	end
end

class Laser < Chingu::GameObject
	has_traits :timer, :velocity

	def setup
		@image = Gosu::Image["laser.png"]
		@width, @height = 22, 30
		if @options[:laser_direction] == 0
			self.velocity_x = -8
		else self.velocity_x = 8
		end
		after(1800) {self.destroy}
	end
end
# 330, 470, 93, 170
# 330, 470, 275, 430

def hittest(thing1, thing2, s_left_X = 0, s_right_X = 0,s_up_y = 0,s_down_y = 0)
	current_x = thing1.x - thing1.width
	x_end = thing1.x + thing1.width
	y_end = thing1.y + thing1.height
	
	if s_left_X != 0
		leftX = s_left_X
		rightX = s_right_X
		upY = s_up_y
		downY = s_down_y
	else
		leftX = thing2.x - thing2.width
		rightX = thing2.x + thing2.width
		upY = thing2.y - thing2.height
		downY = thing2.y + thing2.height
	end
	
	while current_x <= x_end do
		current_y = thing1.y - thing1.height
		while current_y <= y_end do
			if current_x > leftX && current_x < rightX && current_y > upY && current_y < downY
				return true
			end
			current_y += 3
		end
		current_x += 3
	end
	return false
end

Game.new.show
require 'chingu'

class Game < Chingu::Window

	def initialize
		super
		self.input = {esc: :exit}
		@player = Player.create
	end
end

class Player < Chingu::GameObject

	def setup
		@image = Gosu::Image["skepp.png"]
		@x, @y = 350, 400
	end
end

Game.new.show
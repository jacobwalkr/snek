class SnakeSegment
  attr_accessor :y, :x
  attr_reader :sprite

  def initialize(y, x, sprite)
    @y = y
    @x = x
    @sprite = sprite
  end
end


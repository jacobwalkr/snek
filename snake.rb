require_relative "snake_segment"

class Snake
  SPRITE_HEAD = "\u2588\u2588"
  SPRITE_TAIL = "\u2592\u2592"

  def initialize(head_y, head_x)
    # The head
    @head = SnakeSegment.new(head_y, head_x, SPRITE_HEAD)
    @tail = []
  end

  def move(direction)
    # Returns two SnakeSegment arrays (remove, add), like a simplified list of changes
    case direction
    when :up
      @head.y += -1 # grid has Y=0 at the top
    when :down
      @head.y += 1
    when :left
      @head.x += -1
    when :right
      @head.x += 1
    end

    return [], [@head]
  end
end


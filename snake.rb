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
    add = []
    remove = []

    # Put a tail segment where the head was
    replace_head = SnakeSegment.new(@head.y, @head.x, SPRITE_TAIL)
    @tail.unshift(replace_head)
    add.push(replace_head)

    # Move the head
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

    add.push(@head)

    # Remove the end of the tail (combined with above, gives the impression of the whole snake
    # moving without walking the whole tail
    remove.push(@tail.pop)

    return remove, add
  end
end


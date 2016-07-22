require_relative "snake_segment"

class Snake
  attr_reader :head, :tail

  SPRITE_HEAD = "\u2588\u2588"
  SPRITE_TAIL = "\u2592\u2592"

  def initialize(head_y, head_x)
    @head = SnakeSegment.new(head_y, head_x, SPRITE_HEAD)
    @tail = []
    @growing = false
  end

  def move(direction)
    # Returns two SnakeSegment arrays (remove, add), like a simplified list of changes
    add = []
    remove = []

    # Create a tail segment where the head was
    replace_head = SnakeSegment.new(@head.y, @head.x, SPRITE_TAIL)

    # If there *is* a tail, put a segment where the head was and delete the tip of the tail
    # Otherwise, we'll clear where the head was
    # This gives the impression of the tail moving without having to walk the array
    if @tail.length > 0 or @growing
      # Put a tail segment where the head was
      @tail.unshift(replace_head)
      add.push(replace_head)

      # Remove the tip of the tail if the snake hasn't grown
      if not @growing
        remove.push(@tail.pop)
      else
        # Leaves the last piece in place
        @growing = false
      end
    else
      remove.push(replace_head)
    end

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

    return remove, add
  end

  def grow
    @growing = true
  end

  def cannibal?
    # Is the snake eating itself?
    @tail.each do |segment|
      return true if segment.y == @head.y && segment.x == @head.x
    end

    false
  end
end


include Curses

class Game
  def initialize(window, grid_y, grid_x)
    @window = window
    @grid_y = grid_y
    @grid_x = grid_x
  end

  def play
    game_thread = start_game

    # Defaults to moving right at the start of the game
    next_instruction = :right
    loop do
      next_char = Curses.getch

      case next_char
      when KEY_UP
        next_instruction = :up
      when KEY_DOWN
        next_instruction = :down
      when KEY_LEFT
        next_instruction = :left
      when KEY_RIGHT
        next_instruction = :right
      when 10 # The enter key
        game_thread[:stop] = true
        game_thread.join
        break
      end

      game_thread[:next_instruction] = next_instruction
    end
  end

  private
    def start_game
      thread = Thread.start do
        Thread.current[:stop] = false
        Thread.current[:next_instruction] = :right
        snake = Snake.new(@grid_y / 2, @grid_x / 2)

        loop do
          break if Thread.current[:stop]

          remove, add = snake.move(Thread.current[:next_instruction])

          remove.each do |segment|
            @window.setpos(segment.y, segment.x * 2)
            @window.addstr('  ') # two spaces
          end

          add.each do |segment|
            @window.setpos(segment.y, segment.x * 2)
            @window.addstr(segment.sprite)
          end

          if snake.cannibal?
            show_message(@window, 'Dead!')
            Thread.current[:stop] = true
          end

          @window.refresh
          sleep 0.1
        end
      end
    end
end


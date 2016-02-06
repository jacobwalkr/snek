require "curses"
require_relative "snake"

include Curses

def show_message(window, message)
  window.setpos(0, 0)
  window.addstr(message)
end

begin
  Curses.init_screen
  Curses.cbreak
  Curses.curs_set 0
  Curses.noecho
  stdscr.keypad = true
  window = Curses::Window.new 0, 0, 0, 0
  window.nodelay = true
  grid_y = Curses.lines
  grid_x = Curses.cols / 2 # snake is two-wide to make each segment appear as a square

  show_message(window, "Snake!")

  thread = Thread.start do
    Thread.current[:stop] = false
    Thread.current[:next_instruction] = :right
    snake = Snake.new(grid_y / 2, grid_x / 2)

    loop do
      break if Thread.current[:stop]

      remove, add = snake.move(Thread.current[:next_instruction])

      remove.each do |segment|
        window.setpos(segment.y, segment.x * 2)
        window.addstr('  ') # two spaces
      end

      add.each do |segment|
        window.setpos(segment.y, segment.x * 2)
        window.addstr(segment.sprite)
      end

      window.refresh
      sleep 0.1
    end
  end

  #window.addstr thread.status.to_s

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
      thread[:stop] = true
      thread.join
      break
    end

    thread[:next_instruction] = next_instruction
  end
ensure
  Curses.close_screen
end


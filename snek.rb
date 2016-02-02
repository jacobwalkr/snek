require "curses"
include Curses

SNAKE = "\u2588\u2588"

begin
  Curses.init_screen
  Curses.cbreak
  Curses.curs_set 0
  Curses.noecho
  stdscr.keypad = true
  window = Curses::Window.new 0, 0, 0, 0
  window.nodelay = true

  thread = Thread.start do
    Thread.current[:stop] = false
    snake_y = Curses.lines / 2
    snake_x = Curses.cols / 2
    Thread.current[:snake_dir_y] = 0
    Thread.current[:snake_dir_x] = 2

    loop do
      break if Thread.current[:stop]

      window.clear
      window.setpos snake_y, snake_x
      window.addstr SNAKE# + char.to_s
      window.refresh
      snake_y += Thread.current[:snake_dir_y]
      snake_x += Thread.current[:snake_dir_x]
      sleep 0.1
    end
  end

  #window.addstr thread.status.to_s

  y = 0; x = 0
  loop do
    next_char = Curses.getch

    case next_char
    when KEY_UP
      y = -1; x = 0
    when KEY_DOWN
      y = 1; x = 0
    when KEY_LEFT
      y = 0; x = -2
    when KEY_RIGHT
      y = 0; x = 2
    when 10 # The enter key
      thread[:stop] = true
      thread.join
      break
    end

    thread[:snake_dir_y] = y
    thread[:snake_dir_x] = x
  end
ensure
  Curses.close_screen
end


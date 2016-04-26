require "curses"
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

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
  window = Curses::Window.new(0, 0, 0, 0)
  window.nodelay = true
  grid_y = Curses.lines
  grid_x = Curses.cols / 2 # snake is two-wide to make each segment appear as a square

  game = Game.new(window, grid_y, grid_x)
  game.play
ensure
  Curses.close_screen
end


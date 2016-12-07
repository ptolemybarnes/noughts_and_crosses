require 'pry'
require './lib/point'
require './lib/game'
require './lib/grid'
require './lib/mark'
require './lib/moves_list'
require './lib/move'
require './lib/move_decision'
require './lib/move_decision_strategy.rb'

# COMPUTER GOES SECOND
# this script randomly generates moves vs the computer to ensure it always wins when it can
# v messy!

include NoughtsAndCrosses
game  = Game.new
count = 1
turn  = Nought
puts game.print

loop do
  until game.over?
    turn = (turn == Nought ? Cross : Nought)
    if turn == Nought
      move = MoveDecision.make(game.grid, turn)
    else
      available_moves = game.grid.cells.select {|move| move.mark.null_mark? }
      point = Point.new(*gets.chomp.split(' ').map(&:to_i))
      move = Move.new(point, turn)
    end
    game.play(move)
    puts game.print
  end
  puts "#{count} :: GAME OVER!"
  count += 1
  winning_line = game.send(:winning_line)
  if (winning_line && winning_line.first.mark == Cross) || (winning_line.nil? && game.grid.fetch(Point.middle).mark != Cross)
    fail 'Computer lost!'
  end
  game = Game.new
  turn = Nought
end


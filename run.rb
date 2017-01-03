require 'pry'
require './lib/point'
require './lib/game_state'
require './lib/grid'
require './lib/mark'
require './lib/moves_list'
require './lib/move'
require './lib/line'
require './lib/possible_game_states'
require './lib/ideal_move'
require './lib/player'
require './lib/rank_cache'
require './lib/ranker'
require './lib/game'
require './lib/setup_players'
require './lib/print_grid.rb'
require './lib/print_numbered_grid.rb'
require 'colorize'

include NoughtsAndCrosses

class Prompt
  def self.gets
    print '=> '
    STDIN.gets.chomp
  end
end

def colourize(output)
  output
    .gsub(/[1-9]/) {|char| char.light_black }
    .gsub('X', 'X'.red)
end

setup = SetupPlayers.new
until setup.ready?
  begin
    puts setup.prompt
    setup.call(Prompt.gets)
  rescue InvalidInputError
    puts "\nPlease enter a valid number!\n "
  end
end
first_player, second_player = setup.players

events = {
  game_start: Proc.new do |game_state|
    puts "\nGame starting!\n"
    puts colourize(game_state.print)
  end,
  game_over: Proc.new do |game_state|
    puts colourize(game_state.print)
    puts "Game over!"
  end,
  turn_change: Proc.new do |game_state|
    system("clear")
    puts colourize(game_state.print)
  end,
  invalid_move: Proc.new do |game_state, error|
    puts "You can't go there!"
  end
}

class NumberedGrid < PrintGrid
end

game = Game.new(first_player, second_player, events, GameState.new(Grid.new(print_grid: PrintNumberedGrid)))
until game.over?
  game.run
end


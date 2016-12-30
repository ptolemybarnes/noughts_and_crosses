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

include NoughtsAndCrosses

class Prompt

  def self.gets
    print '=> '
    STDIN.gets.chomp
  end

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
    puts game_state.print
  end,
  game_over: Proc.new do |game_state|
    puts game_state.print
    puts "Game over!"
  end,
  turn_change: Proc.new do |game_state|
    system("clear")
    puts game_state.print
  end
}

game = Game.new(first_player, second_player, events)
until game.over?
  begin
    game.run
  rescue YouCantGoThereError
    puts 'Please enter a valid coordinate, x y'
  end
end

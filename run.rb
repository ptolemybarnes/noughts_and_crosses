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
require './lib/numbered_input.rb'
require './lib/prompt'
require 'colorize'

include NoughtsAndCrosses

setup_prompt = Prompt.new do
  print '=> '
end

player_move_prompt = Prompt.new do
  puts 'Enter the number of an empty cell, 1 - 9'
  print '=> '
end
numbered_input = NumberedInput.new(player_move_prompt)

game_types = {
  'Human vs Human'       => [
    CommandLinePlayer.new(input: numbered_input),
    CommandLinePlayer.new(input: numbered_input)
  ],
  'Human vs Computer'    => [
    CommandLinePlayer.new(input: numbered_input),
    ComputerPlayer.new
  ],
  'Computer vs Human'    => [
    CommandLinePlayer.new(input: numbered_input),
    CommandLinePlayer.new(input: numbered_input)
  ],
  'Computer vs Computer' => [
    ComputerPlayer.new,
    ComputerPlayer.new
  ]
}

def colourize(output)
  output
    .gsub(/[1-9]/) {|char| char.light_black }
    .gsub('X', 'X'.red)
end

setup = SetupPlayers.new(game_types)
until setup.ready?
  begin
    puts setup.prompt
    setup.call(setup_prompt.gets)
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
  end,
  invalid_input: Proc.new do |game_state, error|
    puts 'Please enter a cell number, 1 - 9'
  end
}

game = Game.new(first_player, second_player, events, GameState.new(Grid.new(print_grid: PrintNumberedGrid)))
until game.over?
  game.run
end

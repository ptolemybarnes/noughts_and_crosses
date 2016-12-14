require 'pry'
require './lib/point'
require './lib/game'
require './lib/grid'
require './lib/mark'
require './lib/moves_list'
require './lib/move'
require './lib/line'
require './lib/possible_games'
require './lib/ideal_move'
require './lib/player'
require './lib/rank_cache'
require './lib/ranker'
# this script runs the game from the command-line
include NoughtsAndCrosses

class Prompt
  def self.gets
    print "\n=> "
    STDIN.gets
  end
end

MODES = {
  'Human vs Human'       => [HumanPlayer.new(Nought, input: Prompt), HumanPlayer.new(Cross, input: Prompt)],
  'Human vs Computer'    => [HumanPlayer.new(Nought, input: Prompt), ComputerPlayer.new(Cross)],
  'Computer vs Computer' => [ComputerPlayer.new(Nought), ComputerPlayer.new(Cross)]
}

MARKS = {
  'Nought starts' => Nought,
  'Cross starts'  => Cross
}

def present_selection_for(options)
  selection_number = ''
  options_range = (0..options.length)
  is_selection_in_options = Regexp.new(/^[#{ options_range.map(&:to_s).join }]$/)
  until selection_number.match(is_selection_in_options)
    puts "Enter a number\n\n"
    options.each_with_index do |mode, index|
      puts "#{index + 1}. #{mode}"
    end
    selection_number = Prompt.gets.chomp
  end
  selection_number = selection_number.to_i - 1
  puts "\nYou chose '#{options[selection_number]}'\n"
  selection_number
end

game_mode_number = present_selection_for(MODES.keys)
players = MODES.values[game_mode_number].cycle

starting_mark_number = present_selection_for(MARKS.keys)
starting_mark = MARKS.values[starting_mark_number]
players.next if starting_mark == Cross

game = Game.new
puts 'Game starting!'
until game.over?
  begin
    game.play(players.peek.get_move(game.grid))
    players.next
  rescue Player::InvalidInputError, YouCantGoThereError => error
    puts "The move '#{error}' was invalid. Please enter a move 'x, y'."
  end
end

puts game.print
puts 'Game over!'

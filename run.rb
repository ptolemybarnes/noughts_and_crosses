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

  def gets
    print '=> '
    super.chomp
  end

end

setup = SetupPlayers.new
until setup.ready?
  puts setup.prompt
  puts setup.call(Prompt.new)
end

events = {
  game_over: Proc.new do |game_state|
    puts game_state.print
    puts "Game over!"
  end,
  turn_change: Proc.new { |game_state| puts game_state.print }
}

game = Game.new(setup.first_player, setup.second_player, events)
until game.over?
  game.run
end

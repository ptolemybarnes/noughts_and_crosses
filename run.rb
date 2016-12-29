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

include NoughtsAndCrosses
human_player    = CommandLinePlayer.new(Nought)
computer_player = ComputerPlayer.new(Cross)
game = Game.new(human_player, computer_player)

until game.over?
  game.run
end

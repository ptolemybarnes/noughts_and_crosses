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
require './lib/print_grid'
require './lib/print_numbered_grid'
require './lib/numbered_input'
require 'pry'
require './spec/helpers'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.include Helpers
end

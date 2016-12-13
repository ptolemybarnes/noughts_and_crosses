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
require 'pry'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

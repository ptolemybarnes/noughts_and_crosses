# generates the set of possible games from a given game
module NoughtsAndCrosses
  class PossibleGameStates
    def initialize(game)
      @game = game
    end

    def self.make(game, mark)
      new(game).make(mark)
    end

    def make(mark)
      possible_games_with_moves(mark)
    end

    private

    def possible_games_with_moves(mark)
      game.available_points.map do |point|
        move = Move.new(point, mark)
        [game.dup.play(move), move]
      end
    end

    attr_reader :game
  end
end

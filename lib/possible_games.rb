# generates the set of possible games from a given grid
module NoughtsAndCrosses
  class PossibleGames
    def initialize(grid)
      @grid = grid
    end

    def self.make(grid, mark)
      new(grid).make(mark)
    end

    def make(mark)
      possible_games_with_moves(mark)
    end

    def possible_games_with_moves(mark)
      grid.cells.select do |move|
        move.mark.null_mark?
      end.map do |null_move|
        move = Move.new(null_move.point, mark)
        [Game.new(grid.add(move)), move]
      end
    end

    private

    attr_reader :grid
  end
end

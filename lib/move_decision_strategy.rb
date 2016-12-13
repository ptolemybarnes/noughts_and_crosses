module NoughtsAndCrosses
  class MoveDecisionStrategy

    def self.sample(grid, mark)
      make(grid, mark).sample
    end

    def self.make(grid, mark)
      new(grid).make(mark)
    end

    def initialize(grid)
      @grid = grid
    end

    private

    attr_reader :grid
  end

  class PossibleGames < MoveDecisionStrategy

    def make(mark)
      possible_grids_with_moves(mark)
    end

    def possible_grids_with_moves(mark)
      grid.cells.select do |move|
        move.mark.null_mark?
      end.map do |null_move|
        move = Move.new(null_move.point, mark)
        [ Game.new(grid.add(move)), move ]
      end
    end
  end
end

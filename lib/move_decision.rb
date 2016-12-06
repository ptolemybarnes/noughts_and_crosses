module NoughtsAndCrosses
  class MoveDecision

    def self.make(grid, mark)
      new(grid).make(mark)
    end

    def initialize(grid)
      @grid = grid
    end

    def make(mark)
      return Move.new(Point.new(0, 0), mark) if grid.empty?
      winning_move_for(mark) || blocking_move_for(mark) || splitting_move_for(mark) || Move.new(Point.new(0, 2), mark)
    end

    private

    attr_reader :grid

    def winning_move_for(mark)
      WinningMove.make(grid, mark)
    end

    def blocking_move_for(mark)
      BlockingMove.make(grid, mark)
    end

    def splitting_move_for(mark)
      SplittingMove.make(grid, mark)
    end
  end
end

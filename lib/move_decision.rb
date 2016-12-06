module NoughtsAndCrosses
  class MoveDecision

    def self.make(grid, mark)
      new(grid).make(mark)
    end

    def initialize(grid)
      @grid = grid
    end

    def make(mark)
      return opening_move_for(mark) if grid.empty?
      WinningMove.make(grid, mark) or
        BlockingMove.make(grid, mark) or
          SplittingMove.make(grid, mark) or
            second_move_for(mark)
    end

    private

    attr_reader :grid

    def opening_move_for(mark)
      Move.new(Point.new(0, 0), mark)
    end

    def second_move_for(mark)
      if grid.fetch(Point.middle).mark == mark.opponent
        Move.new(Point.top_right, mark)
      else
        Move.new(Point.top_left, mark)
      end
    end
  end
end

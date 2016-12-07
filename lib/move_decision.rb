module NoughtsAndCrosses
  class MoveDecision

    def self.make(grid, mark)
      new(grid).make(mark)
    end

    def initialize(grid)
      @grid = grid
    end

    def make(mark)
        WinningMove.make(grid, mark) or
          BlockingMove.make(grid, mark) or
            SplittingMove.make(grid, mark) or
              GainTempoMove.make(grid, mark) or
                StartingMove.make(grid, mark) or
                  OppositeCornerMove.make(grid, mark) or
                    DefensiveMove.make(grid, mark) or
                      RandomMove.make(grid, mark)
    end

    private

    attr_reader :grid
  end
end

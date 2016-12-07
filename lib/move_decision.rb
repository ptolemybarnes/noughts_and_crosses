module NoughtsAndCrosses
  class MoveDecision

    STRATEGIES = [
      WinningMove,
      BlockingMove,
      SplittingMove,
      GainTempoMove,
      StartingMove,
      OppositeCornerMove,
      DefensiveMove,
      MoveDecisionStrategy
    ]

    def self.make(grid, mark)
      new(grid).make(mark).first
    end

    def initialize(grid)
      @grid = grid
    end

    def make(mark)
      STRATEGIES.find {|strategy| strategy.new(grid).make(mark).any? }
        .new(grid).make(mark)
    end

    private

    attr_reader :grid
  end
end

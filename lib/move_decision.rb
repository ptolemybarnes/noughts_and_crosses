module NoughtsAndCrosses
  class MoveDecision

    STRATEGIES = [
      WinningMoves,
      BlockingMoves,
      SplittingMoves,
      GainTempoMoves,
      StartingMoves,
      OppositeCornerMoves,
      DefensiveMoves,
      PossibleMoves
    ]

    def self.make(grid, mark)
      new(grid).make(mark).first
    end

    def initialize(grid)
      @grid = grid
    end

    def make(mark)
      strategy = STRATEGIES.find {|strategy| strategy.new(grid).make(mark).any? }
      raise 'No applicable decision strategy' if strategy.nil?
      strategy.new(grid).make(mark)
    end

    private

    attr_reader :grid
  end
end

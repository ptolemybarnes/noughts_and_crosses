module NoughtsAndCrosses
  class Game
    attr_reader :grid

    def initialize(grid = Grid.new)
      @grid = grid
    end

    def play(move)
      raise YouCantGoThereError.new("The game is over") if over?
      raise YouCantGoThereError.new("Point #{move.point} doesn't exist") if !Point.all.include? move.point
      @grid = grid.add(move)
      self
    end

    def print
      grid.print
    end

    def over?
      won? || grid.full?
    end

    def won_by?(mark)
      grid.lines.any? {|line| line.all?(mark) }
    end

    private

    def won?
      won_by?(Nought) || won_by?(Cross)
    end
  end

  class RuleViolationError < StandardError; end
  class YouCantGoThereError < RuleViolationError; end
  class NotYourTurnError < RuleViolationError; end
end

module NoughtsAndCrosses
  class Game
    WINNING_LINE_LENGTH = 3

    def initialize
      @grid = Grid.new
    end

    def place_nought_at(point)
      place(Nought, point)
    end

    def place_cross_at(point)
      place(Cross, point)
    end

    def print
        "-----\n|" +
        grid.print +
        "|\n-----\n"
    end

    def over?
      won? || grid.full?
    end

    private

    attr_reader :grid

    def won?
      !winning_line.nil?
    end

    def winning_line
      grid.find_line do |line|
        compacted_line = line.reject {|move| move.mark.null_mark? }
        compacted_line.length == WINNING_LINE_LENGTH && compacted_line.uniq {|move| move.mark }.one?
      end
    end

    def place(mark, point)
      raise YouCantGoThereError.new("The game is over") if over?
      raise YouCantGoThereError.new("Point #{point} doesn't exist") if !Point.all.include? point
      grid.add(Move.new(point, mark))
      self
    end
  end

  class RuleViolationError < StandardError; end
  class YouCantGoThereError < RuleViolationError; end
  class NotYourTurnError < RuleViolationError; end
end

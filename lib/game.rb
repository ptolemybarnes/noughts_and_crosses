module NoughtsAndCrosses
  class Game

    def initialize
      @moves = MovesList.new
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
      won? || moves.complete?
    end

    private

    attr_reader :moves

    def won?
      !winner.nil?
    end

    def winner
      winning_line.first[1] if winning_line
    end

    def winning_line
      grid.find_line do |row|
        compacted_row = row.reject {|move| move.mark.null_mark? }
        compacted_row.length == 3 && compacted_row.uniq {|move| move.mark }.one?
      end
    end

    def place(mark, point)
      raise YouCantGoThereError.new("The game is over") if over?
      raise YouCantGoThereError.new("Point #{point} doesn't exist") if !Point.all.include? point
      moves.add(point, mark)
      self
    end

    def grid
      Grid.new(moves.dup)
    end
  end

  class RuleViolationError < StandardError; end
  class YouCantGoThereError < RuleViolationError; end
  class NotYourTurnError < RuleViolationError; end
end

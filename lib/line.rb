module NoughtsAndCrosses
  class Line

    def initialize(moves)
      @moves = moves
    end

    def three_in_a_row?
      compacted_line = moves.reject {|move| move.mark.null_mark? }
      compacted_line.length == WINNING_LINE_LENGTH && compacted_line.uniq {|move| move.mark }.one?
    end

    def two?(mark)
      moves.count {|move| move.mark == mark } == 2
    end

    def none?(mark)
      moves.none? {|move| move.mark == mark }
    end

    def find &block
      moves.find &block
    end

    def all?(mark)
      moves.all? {|move| move.mark == mark }
    end

    private

    attr_reader :moves
  end
end

module NoughtsAndCrosses
  class MoveDecision

    def self.make(grid, mark)
      new(grid, mark).make
    end

    def initialize(grid, mark)
      @grid, @mark = grid, mark
    end

    def make
      return Move.new(Point.new(0, 0), mark) if grid.empty?
      return winning_move if winning_move
      Move.new(Point.new(0, 2), mark)
    end

    def winning_move
      winning_line = grid.find_line do |line|
        line.select do |move|
          move.mark == mark
        end.length == 2 && line.none? {|move| move.mark == other_mark }
      end
      return false if winning_line.nil?
      Move.new(winning_line.find {|move| move.mark.null_mark? }.point, mark)
    end

    private

    def other_mark
      mark == Nought ? Cross : Nought
    end

    attr_reader :grid, :mark
  end
end

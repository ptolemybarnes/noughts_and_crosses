module NoughtsAndCrosses
  class MoveDecision

    def self.make(grid)
      new(grid).make
    end

    def initialize(grid)
      @grid = grid
    end

    def make
      return Move.new(Point.new(0, 0), Nought) if grid.empty?
      return winning_move if winning_move
      Move.new(Point.new(0, 2), Nought)
    end

    def winning_move
      winning_line = grid.each_line.find do |line|
        line.select do |move|
          move.mark == Nought
        end.length == 2 && line.none? {|move| move.mark == Cross }
      end
      return false if winning_line.nil?
      Move.new(winning_line.find {|move| move.mark.null_mark? }.point, Nought)
    end

    private

    attr_reader :grid
  end
end

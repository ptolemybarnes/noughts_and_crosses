module NoughtsAndCrosses
  class MoveDecision

    def self.make(grid, mark)
      new(grid).make(mark)
    end

    def initialize(grid)
      @grid = grid
    end

    def make(mark)
      return Move.new(Point.new(0, 0), mark) if grid.empty?
      winning_move_for(mark) || blocking_move_for(mark) || Move.new(Point.new(0, 2), mark)
    end

    def blocking_move_for(mark)
      opponent_winning_move_location = winning_move_location_for(other_mark(mark))
      return nil if opponent_winning_move_location.nil?
      Move.new(opponent_winning_move_location, mark)
    end

    def winning_move_for(mark)
      winning_move_point = winning_move_location_for(mark)
      return false if winning_move_point.nil?
      Move.new(winning_move_point, mark)
    end

    def winning_move_location_for(mark)
      winning_line = grid.find_line do |line|
        line.select do |move|
          move.mark == mark
        end.length == 2 && line.none? {|move| move.mark == other_mark(mark) }
      end
      return nil if winning_line.nil?
      winning_line.find {|move| move.mark.null_mark? }.point
    end
    private

    def other_mark(mark)
      mark == Nought ? Cross : Nought
    end

    attr_reader :grid
  end
end

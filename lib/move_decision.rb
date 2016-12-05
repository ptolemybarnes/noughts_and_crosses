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

    private

    def blocking_move_for(mark)
      opponent_winning_move_point = winning_move_point_for(other_mark(mark))
      Move.new(opponent_winning_move_point, mark) if opponent_winning_move_point
    end

    def winning_move_for(mark)
      winning_move_point = winning_move_point_for(mark)
      Move.new(winning_move_point, mark) if winning_move_point
    end

    def winning_move_point_for(mark)
      winning_line = grid.find_line do |line|
        line.count do |move|
          move.mark == mark
        end == 2 && line.none? {|move| move.mark == other_mark(mark) }
      end
      return nil if winning_line.nil?
      winning_line.find {|move| move.mark.null_mark? }.point
    end

    def other_mark(mark)
      mark == Nought ? Cross : Nought
    end

    attr_reader :grid
  end
end

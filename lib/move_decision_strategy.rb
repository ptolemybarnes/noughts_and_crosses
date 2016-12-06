module NoughtsAndCrosses

  class MoveDecisionStrategy
    def self.make(grid, mark)
      new(grid).make(mark)
    end

    def initialize(grid)
      @grid = grid
    end
    private

    attr_reader :grid
  end

  class WinningMove < MoveDecisionStrategy

    def make(mark)
      winning_move_point = winning_move_point_for(mark).first
      Move.new(winning_move_point, mark) if winning_move_point
    end

    def winning_move_point_for(mark)
      winning_lines = winning_lines_for(mark)
      return [] if winning_lines.empty?
      winning_lines.map do |line|
        line.find {|move| move.mark.null_mark? }.point
      end
    end

    def winning_lines_for(mark)
      grid.lines.select do |line|
        line.count do |move|
          move.mark == mark
        end == 2 && line.none? {|move| move.mark == mark.opponent }
      end
    end
  end

  class BlockingMove < MoveDecisionStrategy
    def make(mark)
      opponent_winning_move = WinningMove.make(grid, mark.opponent)
      Move.new(opponent_winning_move.point, mark) if opponent_winning_move
    end
  end

  class SplittingMove < MoveDecisionStrategy
    def make(mark)
      result = grid.cells.select do |move|
        move.mark.null_mark?
      end.map do |null_move|
        Move.new(null_move.point, mark)
      end.map do |move|
        duplicate_grid = grid.dup
        [duplicate_grid.add(move), move]
      end.map do |possible_grid, move|
        [(WinningMove.new(possible_grid).winning_move_point_for(mark) || []), move]
      end.select do |winning_points, move|
        winning_points.count > 1
      end.map do |winning_points, move|
        move
      end.first
    end
  end
end

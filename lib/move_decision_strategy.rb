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

  # finds a 'winning move', a move that creates a line of 3
  class WinningMove < MoveDecisionStrategy
    def make(mark)
      winning_move_point = winning_move_points_for(mark).first
      Move.new(winning_move_point, mark) if winning_move_point
    end

    def winning_move_points_for(mark)
     winning_lines_for(mark).map do |line|
        line.find {|move| move.mark.null_mark? }.point
      end
    end

    private

    def winning_lines_for(mark)
      grid.lines.select do |line|
        line.count do |move|
          move.mark == mark
        end == 2 && line.none? {|move| move.mark == mark.opponent }
      end
    end
  end

  # finds a 'blocking move', a move that stops opponent winning on next turn
  class BlockingMove < MoveDecisionStrategy
    def make(mark)
      opponent_winning_move = WinningMove.make(grid, mark.opponent)
      Move.new(opponent_winning_move.point, mark) if opponent_winning_move
    end
  end

  # finds a 'spitting move', a move that allows certain victory on the next turn.
  class SplittingMove < MoveDecisionStrategy
    def make(mark)
      splitting_moves_for(mark).first
    end

    private

    def splitting_moves_for(mark)
      grid.cells.select do |move|
        move.mark.null_mark?
      end.map do |null_move|
        possible_move = Move.new(null_move.point, mark)
        possible_grid = grid.dup.add(possible_move)
        [WinningMove.new(possible_grid).winning_move_points_for(mark), possible_move]
      end.select do |winning_points, _move|
        winning_points.count > 1
      end.map do |_winning_points, move|
        move
      end
    end
  end
end

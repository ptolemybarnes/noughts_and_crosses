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

    def possible_grids_with_moves(mark)
      grid.cells.select do |move|
        move.mark.null_mark?
      end.map do |null_move|
        move = Move.new(null_move.point, mark)
        [grid.dup.add(move), move]
      end
    end
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

    def splitting_moves_for(mark)
      possible_grids_with_moves(mark).select do |possible_grid, move|
        WinningMove.new(possible_grid).winning_move_points_for(mark).count > 1
      end.map do |possible_grid, move|
        move
      end
    end
  end

  # finds a move that gains 'tempo' (from chess). Sets up both a splitting and blocking move
  class GainTempoMove < MoveDecisionStrategy

    def make(mark)
      tempo_gaining_moves_for(mark).first
    end

    private

    def tempo_gaining_moves_for(mark)
      possible_grids_with_moves(mark).select do |possible_grid, move|
        BlockingMove.make(possible_grid, mark.opponent)
      end.select do |possible_grid, move|
        blocking_move = BlockingMove.make(possible_grid, mark.opponent)
        new_grid = possible_grid.dup.add(blocking_move)
        SplittingMove.make(new_grid, mark)
      end.select do |possible_grid, move|
        blocking_move = BlockingMove.make(possible_grid, mark.opponent)
        new_grid = possible_grid.dup.add(blocking_move)
        new_grid = new_grid.add(SplittingMove.make(new_grid, mark))
        WinningMove.make(new_grid, mark.opponent).nil?
      end.map do |possible_grid, move|
        move
      end
    end
  end

  # finds a move that prevents the opponent from making a splitting move.
  class DefensiveMove < MoveDecisionStrategy

    def make(mark)
      defensive_moves_for(mark).first
    end

    def defensive_moves_for(mark)
      possible_grids_with_moves(mark).select do |possible_grid, move|
        blocking_move = BlockingMove.make(possible_grid, mark.opponent)
        blocking_move && blocking_move != SplittingMove.make(possible_grid, mark.opponent)
      end.map do |possible_grid, move|
        move
      end
    end
  end
end

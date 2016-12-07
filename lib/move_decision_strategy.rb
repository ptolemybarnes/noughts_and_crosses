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
        [grid.add(move), move]
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
        line.two?(mark) && line.none?(mark.opponent)
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
        SplittingMove.make(possible_grid.add(blocking_move), mark)
      end.select do |possible_grid, move|
        blocking_move = BlockingMove.make(possible_grid, mark.opponent)
        blocked_grid = possible_grid.add(blocking_move)
        split_grid = blocked_grid.add(SplittingMove.make(blocked_grid, mark))
        WinningMove.make(split_grid, mark.opponent).nil?
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

  class RandomMove < MoveDecisionStrategy

    def make(mark)
      grid.cells.select {|move| move.mark.null_mark? }
        .map {|available_move| Move.new(available_move.point, mark) }
        .first
    end
  end

  class StartingMove < MoveDecisionStrategy

    def make(mark)
      return starting_opening_move_for(mark)  if grid.empty?
      following_opening_move_for(mark) if opponent_has_played_opener?(mark)
    end

    private

    def opponent_has_played_opener?(mark)
      grid.cells.none? {|move| move.mark == mark } && grid.cells.reject do |move|
        move.mark.null_mark?
      end.one?
    end


    def starting_opening_move_for(mark)
      Move.new(Point.bottom_left, mark)
    end

    def following_opening_move_for(mark)
      return Move.new(Point.middle, mark) if grid.empty_at?(Point.middle)
      [
        Point.top_left, Point.top_right, Point.bottom_left, Point.bottom_right
      ].map {|point| Move.new(point, mark) }.sample
    end
  end

  class OppositeCornerMove < MoveDecisionStrategy
    def make(mark)
      Move.new(Point.top_right, mark) if grid.fetch(Point.top_right).mark.null_mark?
    end
  end
end

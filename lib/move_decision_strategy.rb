module NoughtsAndCrosses
  class MoveDecisionStrategy
    def self.make(grid, mark)
      new(grid).make(mark).sample
    end

    def initialize(grid)
      @grid = grid
    end

    private

    attr_reader :grid
  end

  class PossibleMove < MoveDecisionStrategy

    def make(mark)
      possible_grids_with_moves(mark)
    end

    def possible_grids_with_moves(mark)
      grid.cells.select do |move|
        move.mark.null_mark?
      end.map do |null_move|
        Move.new(null_move.point, mark)
      end
    end
  end

  # finds a 'winning move', a move that creates a line of 3
  class WinningMove < MoveDecisionStrategy
    def make(mark)
      winning_move_points_for(mark).map {|point| Move.new(point, mark) }
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
      move = WinningMove.make(grid, mark.opponent)
      move.nil? ? [] : [ Move.new(move.point, mark) ]
    end
  end

  # finds a 'spitting move', a move that allows certain victory on the next turn.
  class SplittingMove < MoveDecisionStrategy
    def make(mark)
      splitting_moves_for(mark)
    end

    def splitting_moves_for(mark)
      PossibleMove.new(grid).make(mark).select do |move|
        WinningMove.new(grid.add(move)).winning_move_points_for(mark).count > 1
      end
    end
  end

  # finds a move that gains 'tempo' (from chess). Sets up both a splitting and blocking move
  class GainTempoMove < MoveDecisionStrategy

    def make(mark)
      tempo_gaining_moves_for(mark)
    end

    private

    def tempo_gaining_moves_for(mark)
      PossibleMove.new(grid).make(mark).select do |move|
        BlockingMove.make(grid.add(move), mark.opponent)
      end.select do |move|
        possible_grid = grid.add(move)
        blocking_move = BlockingMove.make(grid.add(move), mark.opponent)
        SplittingMove.make(possible_grid.add(blocking_move), mark)
      end.select do |move|
        possible_grid = grid.add(move)
        blocking_move = BlockingMove.make(possible_grid, mark.opponent)
        blocked_grid  = possible_grid.add(blocking_move)
        split_grid    = blocked_grid.add(SplittingMove.make(blocked_grid, mark))
        WinningMove.make(split_grid, mark.opponent).nil?
      end
    end
  end

  # finds a move that prevents the opponent from making a splitting move.
  class DefensiveMove < MoveDecisionStrategy

    def make(mark)
      defensive_moves_for(mark)
    end

    def defensive_moves_for(mark)
      PossibleMove.new(grid).make(mark).select do |move|
        possible_grid = grid.add(move)
        blocking_move = BlockingMove.make(possible_grid, mark.opponent)
        blocking_move && blocking_move != SplittingMove.make(possible_grid, mark.opponent)
      end
    end
  end

  class StartingMove < MoveDecisionStrategy

    def make(mark)
      return [starting_opening_move_for(mark)]  if grid.empty?
      opponent_has_played_opener?(mark) ? following_opening_move_for(mark) : []
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
      return [Move.new(Point.middle, mark)] if grid.empty_at?(Point.middle)
      [
        Point.top_left, Point.top_right, Point.bottom_left, Point.bottom_right
      ].map {|point| Move.new(point, mark) }
    end
  end

  class OppositeCornerMove < MoveDecisionStrategy
    def make(mark)
      [opposite_corner_move(mark)]
    end

    private

    def opposite_corner_move(mark)
      Move.new(Point.top_right, mark) if grid.fetch(Point.top_right).mark.null_mark?
    end
  end
end

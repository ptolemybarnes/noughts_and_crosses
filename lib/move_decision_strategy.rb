module NoughtsAndCrosses
  class MoveDecisionStrategy

    def self.sample(grid, mark)
      make(grid, mark).sample
    end

    def self.make(grid, mark)
      new(grid).make(mark)
    end

    def initialize(grid)
      @grid = grid
    end

    private

    attr_reader :grid
  end

  class PossibleMoves < MoveDecisionStrategy

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

  # finds 'winning moves', moves that creates a line of 3
  class WinningMoves < MoveDecisionStrategy
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

  # finds 'blocking moves', moves that stops opponent winning on next turn
  class BlockingMoves < MoveDecisionStrategy
    def make(mark)
      move = WinningMoves.sample(grid, mark.opponent)
      move.nil? ? [] : [ Move.new(move.point, mark) ]
    end
  end

  # finds 'spitting moves', moves that allows certain victory on the next turn.
  class SplittingMoves < MoveDecisionStrategy
    def make(mark)
      splitting_moves_for(mark)
    end

    def splitting_moves_for(mark)
      PossibleMoves.make(grid, mark).select do |move|
        WinningMoves.make(grid.add(move), mark).count > 1
      end
    end
  end

  # finds moves that gain 'tempo' (from chess). Sets up both a splitting and blocking move
  class GainTempoMoves < MoveDecisionStrategy

    def make(mark)
      tempo_gaining_moves_for(mark)
    end

    private

    def tempo_gaining_moves_for(mark)
      PossibleMoves.make(grid, mark).select do |move|
        BlockingMoves.sample(grid.add(move), mark.opponent)
      end.select do |move|
        puts "MOVE: #{move.inspect}"
        # play the move that forced them to block
        possible_grid = grid.add(move)

        # calculate their blocking move
        blocking_move = BlockingMoves.make(possible_grid, mark.opponent)

        # play their blocking move
        blocked_grid = possible_grid.add(blocking_move.first)

        # calculate our splitting move
        split_moves  = SplittingMoves.make(blocked_grid, mark)

        # we move on if there are no split moves
        next if split_moves.none?

        # take all split moves.
        split_moves.reject do |split_move|
          split_grid = blocked_grid.add(split_move)
          WinningMoves.make(split_grid, mark.opponent).any?
        end.any?
      end
    end
  end

  # finds a move that prevents the opponent from making a splitting move.
  class DefensiveMoves < MoveDecisionStrategy

    def make(mark)
      defensive_moves_for(mark)
    end

    def defensive_moves_for(mark)
      PossibleMoves.make(grid, mark).select do |move|
        possible_grid = grid.add(move)
        blocking_move = BlockingMoves.sample(possible_grid, mark.opponent)
        blocking_move && blocking_move != SplittingMoves.sample(possible_grid, mark.opponent)
      end
    end
  end

  class StartingMoves < MoveDecisionStrategy

    def make(mark)
      Array(starting_move_for(mark))
    end

    private

    def starting_move_for(mark)
      return starting_opening_move_for(mark) if grid.empty?
      following_opening_move_for(mark) if opponent_has_played_opener?(mark)
    end

    def opponent_has_played_opener?(mark)
      grid.cells.none? {|move| move.mark == mark } && grid.cells.reject do |move|
        move.mark.null_mark?
      end.one?
    end

    def starting_opening_move_for(mark)
      [
        Point.bottom_left, Point.top_right, Point.top_left, Point.bottom_right
      ].map {|point| Move.new(point, mark) }
    end

    def following_opening_move_for(mark)
      return Move.new(Point.middle, mark) if grid.empty_at?(Point.middle)
      [
        Point.top_left, Point.top_right, Point.bottom_left, Point.bottom_right
      ].map {|point| Move.new(point, mark) }
    end
  end

  class OppositeCornerMoves < MoveDecisionStrategy
    def make(mark)
      Array(opposite_corner_move(mark))
    end

    private

    def opposite_corner_move(mark)
      is_this_second_move = grid.cells.count {|move| move.mark.null_mark? } == 7
      is_top_right_empty  = grid.fetch(Point.top_right).mark.null_mark?
      is_middle_taken_by_opponent = grid.fetch(Point.middle).mark == mark.opponent
      if is_this_second_move && is_top_right_empty && is_middle_taken_by_opponent
        Move.new(Point.top_right, mark)
      end
    end
  end
end

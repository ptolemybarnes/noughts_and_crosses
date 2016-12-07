module NoughtsAndCrosses
  class MoveDecision

    def self.make(grid, mark)
      new(grid).make(mark)
    end

    def initialize(grid)
      @grid = grid
    end

    def make(mark)
      return starting_opening_move_for(mark) if grid.empty?
      return following_opening_move_for(mark) if opponent_has_played_opener?(mark)
      WinningMove.make(grid, mark) or
        BlockingMove.make(grid, mark) or
          SplittingMove.make(grid, mark) or
            GainTempoMove.make(grid, mark) or
              opposite_corner_move_for(mark) or
                random_available_move_for(grid, mark)
    end

    private

    attr_reader :grid

    def random_available_move_for(grid, mark)
      grid.cells.select {|move| move.mark.null_mark? }
        .map {|available_move| Move.new(available_move.point, mark) }
        .sample
    end

    def opponent_has_played_opener?(mark)
      grid.cells.none? {|move| move.mark == mark } && grid.cells.reject do |move|
        move.mark.null_mark?
      end.one?
    end

    def starting_opening_move_for(mark)
      Move.new(Point.bottom_left, mark)
    end

    def following_opening_move_for(mark)
      return Move.new(Point.middle, mark) if grid.fetch(Point.middle).mark.null_mark?
      [
        Point.top_left, Point.top_right, Point.bottom_left, Point.bottom_right
      ].map {|point| Move.new(point, mark) }.sample
    end

    def opposite_corner_move_for(mark)
      Move.new(Point.top_right, mark) if grid.fetch(Point.top_right).mark.null_mark?
    end
  end
end

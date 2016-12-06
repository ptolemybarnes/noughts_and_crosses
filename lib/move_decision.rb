module NoughtsAndCrosses
  class MoveDecision

    def self.make(grid, mark)
      new(grid).make(mark)
    end

    def initialize(grid)
      @grid = grid
    end

    def make(mark)
      return opening_move_for(mark) if grid.empty?
      return opposite_corner_move(mark) if grid.cells.find do |move|
        move.point == Point.middle && move.mark == mark.opponent
      end
      WinningMove.make(grid, mark) or
        BlockingMove.make(grid, mark) or
          SplittingMove.make(grid, mark) or
            GainTempoMove.make(grid, mark) or
                random_available_move_for(grid, mark)
    end

    private

    attr_reader :grid

    def random_available_move_for(grid, mark)
      grid.cells.select {|move| move.mark.null_mark? }
        .map {|available_move| Move.new(available_move.point, mark) }
        .sample
    end

    def opening_move_for(mark)
      Move.new(Point.bottom_left, mark)
    end

    def opposite_corner_move(mark)
      Move.new(Point.top_right, mark)
    end
  end
end

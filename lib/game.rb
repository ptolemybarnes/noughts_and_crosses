# represents a single game of noughts and crosses
module NoughtsAndCrosses
  class Game
    attr_reader :grid

    def initialize(grid = Grid.new)
      @grid = grid
    end

    def play(move)
      fail YouCantGoThereError.new('The game is over') if over?
      fail YouCantGoThereError.new("Point #{move.point} doesn't exist") unless Point.all.include? move.point
      @grid = grid.add(move)
      self
    end

    def print
      grid.print
    end

    def over?
      won? || grid.full?
    end

    def won_by?(mark)
      grid.lines.any? { |line| line.all?(mark) }
    end

    def available_points
      grid.cells.select do |move|
        move.mark.null_mark?
      end.map(&:point)
    end

    private

    def won?
      won_by?(Nought) || won_by?(Cross)
    end
  end

  class YouCantGoThereError < StandardError; end
end

# represents the state of a game of noughts and crosses
module NoughtsAndCrosses
  class GameState
    attr_reader :grid

    def initialize(grid = Grid.new)
      @grid = grid
    end

    def play(move)
      fail YouCantGoThereError.new('The game is over') if over?
      fail YouCantGoThereError.new("Point #{move.point} doesn't exist") unless Point.all.include? move.point
      fail YouCantGoThereError.new("The point #{move.point} is occupied") unless grid.fetch(move.point).mark.null_mark?
      GameState.new(grid.add(move))
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

    def possible_states(mark)
      PossibleGameStates.make(self, mark)
    end

    private

    def won?
      won_by?(Nought) || won_by?(Cross)
    end
  end

  class YouCantGoThereError < StandardError; end
end

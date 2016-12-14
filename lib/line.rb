module NoughtsAndCrosses
  class Line
    def initialize(moves)
      @moves = moves
    end

    def all?(mark)
      moves.all? { |move| move.mark == mark }
    end

    private

    attr_reader :moves
  end
end

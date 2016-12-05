module NoughtsAndCrosses
  class MovesList
    MAX_MOVES = 9

    def initialize(moves = [])
      @moves = moves
    end

    def add(point, mark)
      new_move = Move.new(point, mark)
      raise YouCantGoThereError if moves.find {|move| move.point == new_move.point }
      raise NotYourTurnError if last && (last[1] == new_move.mark)
      moves << new_move
    end

    def next_move
      last[1] == 'X' ? '0' : 'X'
    end

    def fetch(point)
      moves.find {|move| move.point == point } || Move.new(point, NullMark)
    end

    def dup
      MovesList.new(moves.dup)
    end

    def complete?
      moves.length == MAX_MOVES
    end

    private

    attr_reader :moves

    def last
      moves.last
    end
  end
end

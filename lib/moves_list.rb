module NoughtsAndCrosses
  class MovesList
    MAX_MOVES = 9

    def initialize(moves = [])
      @moves = moves
    end

    def add(point, mark)
      new_move = Move.new(point, mark)
      raise YouCantGoThereError if find_move_at(new_move.point)
      raise NotYourTurnError    if last_move && (last_move[1] == new_move.mark)
      moves << new_move
      self
    end

    def fetch(point)
      find_move_at(point) || Move.new(point, NullMark)
    end

    def complete?
      moves.length == MAX_MOVES
    end

    def dup
      MovesList.new(moves.dup)
    end

    private

    attr_reader :moves

    def find_move_at(other_point)
      available_moves.find {|move| move.point == other_point }
    end

    def available_moves
      moves.reject {|move| move.mark.null_mark? }
    end

    def last_move
      moves.last
    end
  end
end

module NoughtsAndCrosses
  class MovesList
    MAX_MOVES = 9

    def initialize(moves = [])
      @moves = moves
    end

    def add(new_move)
      fail YouCantGoThereError.new("#{new_move.point} is already taken") if find_move_at(new_move.point)
      MovesList.new(moves.dup << new_move)
    end

    def fetch(point)
      find_move_at(point)
    end

    private

    attr_reader :moves

    def find_move_at(other_point)
      available_moves.find { |move| move.point == other_point }
    end

    def available_moves
      moves.reject { |move| move.mark.null_mark? }
    end
  end
end

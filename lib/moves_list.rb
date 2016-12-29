# represents a series of move
module NoughtsAndCrosses
  class MovesList

    def initialize(moves = [])
      @moves = moves
    end

    def add(new_move)
      fail YouCantGoThereError.new("#{new_move.point.to_s} is already taken") if find_move_at(new_move.point)
      MovesList.new(moves.dup << new_move)
    end

    def fetch(point)
      find_move_at(point)
    end

    private

    attr_reader :moves

    def find_move_at(other_point)
      moves.find { |move| move.point == other_point }
    end
  end
end

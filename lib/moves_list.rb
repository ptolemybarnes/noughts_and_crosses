module NoughtsAndCrosses
  class MovesList
    MAX_MOVES = 9

    def initialize(moves = {})
      @moves = moves
    end

    def add(location, content)
      raise YouCantGoThereError if moves[location]
      raise NotYourTurnError if last && last[1] == content
      moves[location] = content
    end

    def next_move
      last[1] == 'X' ? '0' : 'X'
    end

    def fetch(key, default = NullMark)
      moves.fetch(key, default)
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
      moves.to_a.last
    end
  end
end

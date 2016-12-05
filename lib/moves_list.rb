module NoughtsAndCrosses

  class Grid
  end

  class MovesList

    def initialize(moves = {})
      @moves = moves
    end

    def add(location, content)
      raise YouCantGoThereError if moves[location]
      raise NotYourTurnError if !empty? && last[1] == content
      moves[location] = content
    end

    def fetch(key, default = NullMark)
      moves.fetch(key, default)
    end

    def length
      moves.length
    end

    def each_line
      lines = [
        [ Point.new(0, 0), Point.new(1, 1), Point.new(2, 2) ],
        [ Point.new(2, 0), Point.new(1, 1), Point.new(0, 2) ]
      ].map {|arr| arr.map {|point| [ point, moves.fetch(point)] }}.concat(each_row).concat(each_column)
      lines.to_enum
    end

    def each_row
      LOCATIONS.each_slice(3).map do |row|
        row.map {|location| [location, fetch(location)] }
      end
    end

    def each_column
      rotate(LOCATIONS.each_slice(3).to_a).map do |row|
        row.map {|location| [location, fetch(location)] }
      end
    end

    def full?
      moves.length > 8
    end

    def dup
      self.class.new(moves.dup)
    end

    def empty?
      moves.empty?
    end

    def next_move
      last[1] == 'X' ? '0' : 'X'
    end

    private

    attr_reader :moves

    def rotate(two_dimensional_array)
      two_dimensional_array.inject {|sum, row| sum.zip(row) }.map(&:flatten)
    end

    def last
      moves.to_a.last
    end
  end
end

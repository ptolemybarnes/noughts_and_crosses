module NoughtsAndCrosses
  class Grid

    def initialize(moves)
      @moves = moves
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

    def rotate(two_dimensional_array)
      two_dimensional_array.inject {|sum, row| sum.zip(row) }.map(&:flatten)
    end

    def full?
      moves.length > 8
    end

    def dup
      self.class.new(moves.dup)
    end

    def empty?
      moves.each_position.all? do |position, content|
        content.null_mark?
      end
    end

    def fetch(key, default = NullMark)
      moves.fetch(key, default)
    end

    private

    attr_reader :moves

  end
end

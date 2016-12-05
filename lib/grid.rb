module NoughtsAndCrosses
  class Grid

    FORWARD_DIAGONAL  = [ Point.new(0, 0), Point.new(1, 1), Point.new(2, 2) ].freeze
    BACKWARD_DIAGONAL = [ Point.new(2, 0), Point.new(1, 1), Point.new(0, 2) ].freeze

    def initialize(moves)
      @moves = moves
    end

    def each_line
      lines = [ FORWARD_DIAGONAL, BACKWARD_DIAGONAL ].map do |arr|
        arr.map {|point| [ point, moves.fetch(point)] }
      end.concat(each_row).concat(each_column).to_enum
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
      moves.each_position.all? do |position, content|
        content.null_mark?
      end
    end

    def fetch(key, default = NullMark)
      moves.fetch(key, default)
    end

    private

    attr_reader :moves

    def rotate(two_dimensional_array)
      two_dimensional_array.inject {|sum, row| sum.zip(row) }.map(&:flatten)
    end

  end
end

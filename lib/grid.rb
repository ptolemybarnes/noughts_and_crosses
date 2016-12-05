module NoughtsAndCrosses
  class Grid
    FORWARD_DIAGONAL  = [ Point.new(0, 0), Point.new(1, 1), Point.new(2, 2) ].freeze
    BACKWARD_DIAGONAL = [ Point.new(2, 0), Point.new(1, 1), Point.new(0, 2) ].freeze

    def initialize(moves)
      @moves = moves
    end

    def each_line
      lines = [ FORWARD_DIAGONAL, BACKWARD_DIAGONAL ].map do |arr|
        arr.map {|point| fetch(point) }
      end.concat(each_row).concat(each_column).to_enum
    end

    def dup
      self.class.new(moves.dup)
    end

    def fetch(key)
      moves.fetch(key)
    end

    def print
      each_row.map do |row|
        row.map { |move| move.mark.to_s }
      end.map(&:join).join("|\n|")
    end

    def empty?
      each_point.all? {|move| move.mark.null_mark? }
    end

    private

    attr_reader :moves

    def each_point
      POINTS.map {|point| fetch(point) }.to_enum
    end

    def each_row
      POINTS.each_slice(3).map do |row|
        row.map {|point| fetch(point) }
      end
    end

    def each_column
      rotate(POINTS.each_slice(3).to_a).map do |row|
        row.map {|point| fetch(point) }
      end
    end

    def rotate(two_dimensional_array)
      two_dimensional_array.inject {|sum, row| sum.zip(row) }.map(&:flatten)
    end

  end
end

module NoughtsAndCrosses
  class Grid
    FORWARD_DIAGONAL  = [ Point.new(0, 0), Point.new(1, 1), Point.new(2, 2) ].freeze
    BACKWARD_DIAGONAL = [ Point.new(2, 0), Point.new(1, 1), Point.new(0, 2) ].freeze

    def initialize(moves)
      @moves = moves
    end

    def fetch(point)
      moves.fetch(point)
    end

    def find_line &block
      [ FORWARD_DIAGONAL, BACKWARD_DIAGONAL ].map do |arr|
        arr.map {|point| fetch(point) }
      end.concat(rows).concat(columns).find &block
    end

    def print
      rows.map do |row|
        row.map { |move| move.mark.to_s }
      end.map(&:join).join("|\n|")
    end

    def empty?
      each_point.all? {|move| move.mark.null_mark? }
    end

    def dup
      self.class.new(moves.dup)
    end

    private

    attr_reader :moves

    def each_point
      POINTS.map {|point| fetch(point) }.to_enum
    end

    def rows
      POINTS.each_slice(3).map do |row|
        row.map {|point| fetch(point) }
      end
    end

    def columns
      rotate(POINTS.each_slice(3).to_a).map do |row|
        row.map {|point| fetch(point) }
      end
    end

    def rotate(two_dimensional_array)
      two_dimensional_array.inject {|sum, row| sum.zip(row) }.map(&:flatten)
    end

  end
end

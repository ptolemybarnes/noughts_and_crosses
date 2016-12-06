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

    def lines
      [ FORWARD_DIAGONAL, BACKWARD_DIAGONAL ].map do |arr|
        arr.map {|point| fetch(point) }
      end.concat(rows.to_a).concat(columns)
    end

    def cells
      POINTS.map {|point| fetch(point) }
    end

    def find_line &block
      lines.find &block
    end

    def print
      rows.map do |row|
        row.map { |move| move.mark.to_s }
      end.map(&:join).join("|\n|")
    end

    def empty?
      lines.all? {|line| line.all? {|move| move.mark.null_mark? }}
    end

    def dup
      self.class.new(moves.dup)
    end

    def add(move)
      moves.add(move.point, move.mark)
      self
    end

    private

    attr_reader :moves

    def rows
      cells.each_slice(3)
    end

    def columns
      rotate(rows.to_a)
    end

    def rotate(two_dimensional_array)
      two_dimensional_array.inject {|sum, row| sum.zip(row) }.map(&:flatten)
    end

  end
end

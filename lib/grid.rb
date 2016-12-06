module NoughtsAndCrosses
  class Grid
    FORWARD_DIAGONAL  = [ Point.bottom_left, Point.middle, Point.top_right ].freeze
    BACKWARD_DIAGONAL = [ Point.top_left, Point.middle, Point.bottom_right ].freeze

    def initialize(moves = MovesList.new)
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
      Point.all.map {|point| fetch(point) }
    end

    def find_line &block
      lines.find &block
    end

    def print
      "-----\n|" +
      rows.map do |row|
        row.map { |move| move.mark.to_s }
      end.map(&:join).join("|\n|") +
      "|\n-----\n"
    end

    def empty?
      cells.all? {|move| move.mark.null_mark? }
    end

    def full?
      cells.none? {|move| move.mark.null_mark? }
    end

    def dup
      self.class.new(moves.dup)
    end

    def add(move)
      moves.add(move)
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

module NoughtsAndCrosses
  class Grid
    FORWARD_DIAGONAL  = [ Point.bottom_left, Point.middle, Point.top_right ].freeze
    BACKWARD_DIAGONAL = [ Point.top_left, Point.middle, Point.bottom_right ].freeze

    def initialize(moves = MovesList.new)
      @moves = moves
    end

    def fetch(point)
      moves.fetch(point) || Move.new(point, NullMark)
    end

    def lines
      [ FORWARD_DIAGONAL, BACKWARD_DIAGONAL ].map do |arr|
        arr.map {|point| fetch(point) }
      end.concat(rows).concat(columns).map {|moves| Line.new(moves) }
    end

    def cells
      Point.all.map {|point| fetch(point) }
    end

    def print
      "-----\n|" +
      rows.map do |row|
        row.map { |move| move.mark.to_s }
      end.map(&:join).join("|\n|") +
      "|\n-----\n"
    end

    def empty?
      lines.all? {|line| line.all?(NullMark) }
    end

    def full?
      cells.none? {|move| move.mark.null_mark? }
    end

    def add(move)
      Grid.new(moves.add(move))
    end

    private

    attr_reader :moves

    def rows
      cells.each_slice(3).to_a
    end

    def columns
      rotate(rows)
    end

    def rotate(two_dimensional_array)
      two_dimensional_array.inject {|sum, row| sum.zip(row) }.map(&:flatten)
    end

  end
end

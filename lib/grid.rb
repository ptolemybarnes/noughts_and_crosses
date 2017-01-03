# allows iteration across the 3x3 grid of moves or empty cells
module NoughtsAndCrosses

  class Grid
    FORWARD_DIAGONAL  = [Point.bottom_left, Point.middle, Point.top_right].freeze
    BACKWARD_DIAGONAL = [Point.top_left, Point.middle, Point.bottom_right].freeze

    def initialize(moves: MovesList.new, print_grid: PrintGrid)
      @moves = moves
      @print_grid = print_grid
    end

    def fetch(point)
      moves.fetch(point) || Move.new(point, NullMark)
    end

    def lines
      [FORWARD_DIAGONAL, BACKWARD_DIAGONAL].map do |diagonal|
        diagonal.map { |point| fetch(point) }
      end.concat(rows).concat(columns).map { |moves| Line.new(moves) }
    end

    def cells
      Point.all.map { |point| fetch(point) }
    end

    def print
      @print_grid.call(print_rows)
    end

    def empty?
      lines.all? { |line| line.all?(NullMark) }
    end

    def full?
      cells.none? { |move| move.mark.null_mark? }
    end

    def add(move)
      Grid.new(moves: moves.add(move), print_grid: @print_grid)
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
      two_dimensional_array.inject { |sum, row| sum.zip(row) }.map(&:flatten)
    end

    def print_rows
      rows.map do |row|
        row.map { |move| move.mark.to_s }.push("|\n").unshift("|")
      end.push("-----\n").unshift("-----\n")
    end
  end
end

module NoughtsAndCrosses
  class Point < Struct.new(:x, :y)
  end

  LOCATIONS = [
    Point.new(0, 2),
    Point.new(1, 2),
    Point.new(2, 2),
    Point.new(0, 1),
    Point.new(1, 1),
    Point.new(2, 1),
    Point.new(0, 0),
    Point.new(1, 0),
    Point.new(2, 0)
  ]

  class Game

    def initialize
      @moves = []
    end

    def place_nought_at(x, y)
      place("0", Point.new(x, y))
    end

    def place_cross_at(x, y)
      place("X", Point.new(x, y))
    end

    def print_grid
        "-----\n|" +
        _print_grid +
        "|\n-----\n"
    end

    IsLineOfThree = proc do |row|
      row = row.compact
      row.length == 3 && row.uniq.one?
    end

    def over?
      moves_and_marks = moves.to_h
      grid = map_to_grid {|location| moves_and_marks[location] }
      forward_slash_diagonal  = grid.to_a.reverse.map.with_index {|arr, idx| arr[idx] }
      backward_slash_diagonal = grid.map.with_index {|arr, idx| arr[idx] }
      (grid.any? &IsLineOfThree) || (rotate(grid).any? &IsLineOfThree) || IsLineOfThree.(forward_slash_diagonal) || IsLineOfThree.(backward_slash_diagonal)
    end

    def rotate(two_dimensional_array)
      two_dimensional_array.inject {|sum, row| sum.zip(row) }.map(&:flatten)
    end

    private

    def map_to_grid &block
      LOCATIONS.map(&block).each_slice(3)
    end

    def place(mark, location)
      raise YouCantGoThereError.new("location #{location} doesn't exist") if !LOCATIONS.include? location
      raise YouCantGoThereError  if moves.any? {|move| move.first == location }
      raise NotYourTurnError if !moves.empty? && moves.last[1] == mark
      moves << [location, mark]
      self
    end

    def _print_grid
      moves_and_marks = moves.to_h
      map_to_grid do |location|
        moves_and_marks.fetch(location, " ")
      end.map(&:join).join("|\n|")
    end

    attr_reader :moves
  end

  class RuleViolationError < StandardError; end
  class YouCantGoThereError < RuleViolationError; end
  class NotYourTurnError < RuleViolationError; end
end

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

  class MovesList

    def initialize(moves = {})
      @moves = moves
    end

    def add(location, content)
      raise YouCantGoThereError  if moves[location]
      raise NotYourTurnError if !empty? && last[1] == content
      moves[location] = content
    end

    def fetch(key, default = nil)
      moves.fetch(key, default)
    end

    def length
      moves.length
    end

    def any? &block
      moves.any? &block
    end

    def each_row
      LOCATIONS.each_slice(3).map do |row|
        row.map {|location| fetch(location) }
      end
    end

    def each_column
      rotate(LOCATIONS.each_slice(3).to_a).map do |row|
        row.map {|location| fetch(location) }
      end
    end

    private

    def rotate(two_dimensional_array)
      two_dimensional_array.inject {|sum, row| sum.zip(row) }.map(&:flatten)
    end

    def empty?
      moves.empty?
    end

    def last
      moves.to_a.last
    end

    attr_reader :moves
  end

  class Game

    def initialize
      @moves = MovesList.new
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
      forward_slash_diagonal = [Point.new(0, 0), Point.new(1, 1), Point.new(2, 2)].map do |point|
        moves.fetch(point)
      end
      backward_slash_diagonal = [Point.new(2, 0), Point.new(1, 1), Point.new(0, 2)].map do |point|
        moves.fetch(point)
      end
      (moves.each_row.any? &IsLineOfThree) || (moves.each_column.any? &IsLineOfThree) || IsLineOfThree.(forward_slash_diagonal) || IsLineOfThree.(backward_slash_diagonal) || moves.length == 9
    end

    private

    attr_reader :moves

    def place(mark, location)
      raise YouCantGoThereError.new("The game is over") if over?
      raise YouCantGoThereError.new("location #{location} doesn't exist") if !LOCATIONS.include? location
      moves.add(location, mark)
      self
    end

    def _print_grid
      moves.each_row.map do |row|
        row.map {|content| content.nil? ? " " : content }
      end.map(&:join).join("|\n|")
    end
  end

  class RuleViolationError < StandardError; end
  class YouCantGoThereError < RuleViolationError; end
  class NotYourTurnError < RuleViolationError; end
end

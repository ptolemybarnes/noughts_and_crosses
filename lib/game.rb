module NoughtsAndCrosses
  class Point < Struct.new(:x, :y)
  end

  class Computer

    def decide_move(moves_list)
      Point.new(0, 0)
    end
  end

  LOCATIONS = [
    [0, 2], [1, 2], [2, 2],
    [0, 1], [1, 1], [2, 1],
    [0, 0], [1, 0], [2, 0]
  ].map {|coordinate| Point.new(*coordinate) }

  class Game

    def initialize
      @moves = MovesList.new
    end

    def place_nought_at(point)
      place("0", point)
    end

    def place_cross_at(point)
      place("X", point)
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
      winner? || moves.full?
    end

    def moves
      @moves
    end

    private

    def winner?
      forward_slash_diagonal = [
        Point.new(0, 0), Point.new(1, 1), Point.new(2, 2)
      ].map { |point| moves.fetch(point) }
      backward_slash_diagonal = [
        Point.new(2, 0), Point.new(1, 1), Point.new(0, 2)
      ].map { |point| moves.fetch(point) }
      (moves.each_row.any? &IsLineOfThree) || (moves.each_column.any? &IsLineOfThree) || IsLineOfThree.(forward_slash_diagonal) || IsLineOfThree.(backward_slash_diagonal)
    end

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

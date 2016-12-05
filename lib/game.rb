module NoughtsAndCrosses
  LOCATIONS = [
    [0, 2], [1, 2], [2, 2],
    [0, 1], [1, 1], [2, 1],
    [0, 0], [1, 0], [2, 0]
  ].map {|coordinate| Point.new(*coordinate) }

  class Nought
    def self.null_mark?
      false
    end
  end

  class Cross
    def self.null_mark?
      false
    end
  end

  class NullMark
    def self.null_mark?
      true
    end
  end

  class Game

    def initialize
      @moves = MovesList.new
    end

    def place_nought_at(point)
      place(Nought, point)
    end

    def place_cross_at(point)
      place(Cross, point)
    end

    def print_grid
        "-----\n|" +
        _print_grid +
        "|\n-----\n"
    end

    IsLineOfThree = proc do |row|
      compacted_row = row.reject {|position, content| content.null_mark? }
      compacted_row.length == 3 && compacted_row.uniq {|k, v| v }.one?
    end

    def over?
      winner? || grid.full?
    end

    def moves
      @moves
    end

    private

    def winner?
      forward_slash_diagonal = [
        Point.new(0, 0), Point.new(1, 1), Point.new(2, 2)
      ].map { |point| [point, grid.fetch(point)] }
      backward_slash_diagonal = [
        Point.new(2, 0), Point.new(1, 1), Point.new(0, 2)
      ].map { |point| [point, grid.fetch(point)] }
      (grid.each_row.any? &IsLineOfThree) || (grid.each_column.any? &IsLineOfThree) || IsLineOfThree.(forward_slash_diagonal) || IsLineOfThree.(backward_slash_diagonal)
    end

    def place(mark, location)
      raise YouCantGoThereError.new("The game is over") if over?
      raise YouCantGoThereError.new("location #{location} doesn't exist") if !LOCATIONS.include? location
      moves.add(location, mark)
      self
    end

    def grid
      Grid.new(moves)
    end

    def _print_grid
      grid.each_row.map do |row|
        row.map do |_position, content|
          if content.null_mark?
            ' '
          elsif content == Nought
            '0'
          else
            'X'
          end
        end
      end.map(&:join).join("|\n|")
    end
  end

  class RuleViolationError < StandardError; end
  class YouCantGoThereError < RuleViolationError; end
  class NotYourTurnError < RuleViolationError; end
end

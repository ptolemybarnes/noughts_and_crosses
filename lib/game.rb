module NoughtsAndCrosses
  class Game

    LOCATIONS = [
      :top_left, :top_middle, :top_right, :middle_left, :middle, :middle_right,
      :bottom_left, :bottom_middle, :bottom_right
    ]

    def initialize
      @moves = []
    end

    def place_nought_at(location)
      place("0", location)
    end

    def place_cross_at(location)
      place("X", location)
    end

    def print_grid
        "-----\n|" +
        _print_grid +
        "|\n-----\n"
    end

    def over?
      moves_and_marks = moves.to_h
      rows_array = LOCATIONS.map do |location|
        moves_and_marks.fetch(location, nil)
      end.each_slice(3).to_a
      # check rows
      rows_outcome = rows_array.any? do |row|
        row = row.compact
        row.length == 3 && row.uniq.one?
      end
      return rows_outcome if rows_outcome

      # check columns
      columns_array = rows_array.inject {|sum, row| sum.zip(row) }.map(&:flatten)
      columns_array.any? do |row|
        row = row.compact
        row.length == 3 && row.uniq.one?
      end
    end

    private

    def place(mark, location)
      raise YouCantGoThereError.new("location #{location} doesn't exist") if !LOCATIONS.include? location
      raise YouCantGoThereError  if moves.any? {|move| move.first == location }
      raise NotYourTurnError if !moves.empty? && moves.last[1] == mark
      moves << [location, mark]
    end

    def _print_grid
      moves_and_marks = moves.to_h
      LOCATIONS.map do |location|
        moves_and_marks.fetch(location, " ")
      end.each_slice(3).to_a.map(&:join).join("|\n|")
    end

    attr_reader :moves
  end

  class RuleViolationError < StandardError; end
  class YouCantGoThereError < RuleViolationError; end
  class NotYourTurnError < RuleViolationError; end
end

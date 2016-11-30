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

    private

    def place(mark, location)
      raise CellOccupiedError  if moves.any? {|move| move.first == location }
      raise RuleViolationError if !moves.empty? && moves.last[1] == mark
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
  class CellOccupiedError < RuleViolationError; end
end


module NoughtsAndCrosses

  describe Game do
    it 'placing a 0 on the grid' do
      game = Game.new
      game.place_nought_at(:middle)

      expect(game.print_grid).to eq(<<~EXAMPLE
        -----
        |   |
        | 0 |
        |   |
        -----
      EXAMPLE
      )
    end

    it 'placing a 0 followed by an X' do
      game = Game.new
      game.place_nought_at(:middle)
      game.place_cross_at(:middle_left)

      expect(game.print_grid).to eq(<<~EXAMPLE
        -----
        |   |
        |X0 |
        |   |
        -----
      EXAMPLE
      )
    end

    describe "rule violations" do
      it "doesn't allow two 0s to be placed consecutively" do
        game = Game.new
        game.place_nought_at(:middle)

        expect { game.place_nought_at(:top_right) }.to raise_error(RuleViolationError)
      end

      it "doesn't allow two crosses to be placed consecutively" do
        game = Game.new
        game.place_cross_at(:middle)

        expect { game.place_cross_at(:middle) }.to raise_error(RuleViolationError)
      end

      it "doesn't allow you to place in an occupied location" do
        game = Game.new
        game.place_cross_at(:middle)

        expect { game.place_nought_at(:middle) }.to raise_error(CellOccupiedError)
      end
    end
  end
end

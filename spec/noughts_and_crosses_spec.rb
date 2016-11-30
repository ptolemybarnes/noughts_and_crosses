require './lib/game'
require 'pry'

module NoughtsAndCrosses
  describe Game do
    let(:game) { Game.new }

    it 'placing a 0 on the grid' do
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

    it 'a game is not over unless a player has 3 in a row' do
      expect(game).not_to be_over
    end

    it 'the game is over when there are 3 noughts horizontally' do
      game.place_nought_at(:middle_left)
      game.place_cross_at(:top_left)
      game.place_nought_at(:middle)
      game.place_cross_at(:top_middle)
      game.place_nought_at(:middle_right)

      expect(game).to be_over
    end

    it 'the game is over when there are 3 crosses vertically' do
      game.place_cross_at(:bottom_left)
      game.place_nought_at(:bottom_middle)
      game.place_cross_at(:middle_left)
      game.place_nought_at(:middle)
      game.place_cross_at(:top_left)

      expect(game).to be_over
    end

    describe "rule violations" do
      it "doesn't allow two 0s to be placed consecutively" do
        game.place_nought_at(:middle)

        expect { game.place_nought_at(:top_right) }.to raise_error(NotYourTurnError)
      end

      it "doesn't allow two crosses to be placed consecutively" do
        game.place_cross_at(:middle)

        expect { game.place_cross_at(:top_left) }.to raise_error(NotYourTurnError)
      end

      it "doesn't allow marks in an occupied location" do
        game.place_cross_at(:middle)

        expect { game.place_nought_at(:middle) }.to raise_error(YouCantGoThereError)
      end

      it "doesn't allow marks in unknown locations" do
        expect { game.place_cross_at(:far_left) }.to raise_error(YouCantGoThereError)
      end
    end
  end
end

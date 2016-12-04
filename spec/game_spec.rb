require './lib/game'
require 'pry'

module NoughtsAndCrosses
  describe Game do
    let(:game) { Game.new }

    TOP_LEFT      = [0, 2]
    TOP_MIDDLE    = [1, 2]
    TOP_RIGHT     = [2, 2]
    MIDDLE_LEFT   = [0, 1]
    MIDDLE        = [1, 1]
    MIDDLE_RIGHT  = [2, 1]
    BOTTOM_LEFT   = [0, 0]
    BOTTOM_MIDDLE = [1, 0]
    BOTTOM_RIGHT  = [2, 0]

    it 'placing a 0 on the grid' do
      game.place_nought_at(*MIDDLE)

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
      game.place_nought_at(*MIDDLE)
        .place_cross_at(*MIDDLE_LEFT)

      expect(game.print_grid).to eq(<<~EXAMPLE
        -----
        |   |
        |X0 |
        |   |
        -----
      EXAMPLE
      )
    end

    describe 'Game Over!' do

      it 'is not over unless a player has 3 in a row' do
        expect(game).not_to be_over
      end

      it 'is over when there are 3 noughts horizontally' do
        game.place_nought_at(*MIDDLE)
          .place_cross_at(*BOTTOM_MIDDLE)
          .place_nought_at(*MIDDLE_LEFT)
          .place_cross_at(*BOTTOM_RIGHT)
          .place_nought_at(*MIDDLE_RIGHT)

        expect(game).to be_over
      end

      it 'is over when there are 3 crosses vertically' do
        game.place_cross_at(*BOTTOM_LEFT)
          .place_nought_at(*BOTTOM_MIDDLE)
          .place_cross_at(*MIDDLE_LEFT)
          .place_nought_at(*MIDDLE)
          .place_cross_at(*TOP_LEFT)

        expect(game).to be_over
      end
    end

    it 'is over when there are 3 crosses diagonally forward (/)' do
      game.place_cross_at(*BOTTOM_LEFT)
        .place_nought_at(*BOTTOM_MIDDLE)
        .place_cross_at(*MIDDLE)
        .place_nought_at(*BOTTOM_RIGHT)
        .place_cross_at(*TOP_RIGHT)

      expect(game).to be_over
    end

    it 'is over when there are 3 noughts diagonally backward (\)' do
      game.place_nought_at(*BOTTOM_RIGHT)
        .place_cross_at(*BOTTOM_MIDDLE)
        .place_nought_at(*MIDDLE)
        .place_cross_at(*BOTTOM_LEFT)
        .place_nought_at(*TOP_LEFT)

      expect(game).to be_over
    end

    it 'is over when the grid is full but there is no winner' do
      game.place_nought_at(*TOP_MIDDLE)
        .place_cross_at(*BOTTOM_LEFT)
        .place_nought_at(*BOTTOM_RIGHT)
        .place_cross_at(*MIDDLE_RIGHT)
        .place_nought_at(*MIDDLE)
        .place_cross_at(*BOTTOM_MIDDLE)
        .place_nought_at(*TOP_RIGHT)
        .place_cross_at(*TOP_LEFT)
        .place_nought_at(*MIDDLE_LEFT)

      expect(game).to be_over
    end

    describe "rule violations" do
      it "doesn't allow two 0s to be placed consecutively" do
        game.place_nought_at(*MIDDLE)

        expect { game.place_nought_at(*TOP_RIGHT) }.to raise_error(NotYourTurnError)
      end

      it "doesn't allow two crosses to be placed consecutively" do
        game.place_cross_at(*MIDDLE)

        expect { game.place_cross_at(*TOP_LEFT) }.to raise_error(NotYourTurnError)
      end

      it "doesn't allow marks in an occupied location" do
        game.place_cross_at(*MIDDLE)

        expect { game.place_nought_at(*MIDDLE) }.to raise_error(YouCantGoThereError)
      end

      it "doesn't allow marks in a location off the grid" do
        expect { game.place_cross_at(20, 20) }.to raise_error(YouCantGoThereError)
      end

      it "doesn't allow further moves when the game is over" do
        game.place_nought_at(*MIDDLE)
          .place_cross_at(*BOTTOM_MIDDLE)
          .place_nought_at(*MIDDLE_LEFT)
          .place_cross_at(*BOTTOM_RIGHT)
          .place_nought_at(*MIDDLE_RIGHT)

        expect { game.place_cross_at(*TOP_LEFT) }.to raise_error(YouCantGoThereError)
      end
    end
  end
end

require 'pry'
require './lib/point'
require './lib/game'
require './lib/grid'
require './lib/mark'
require './lib/moves_list'
require './lib/move'

module NoughtsAndCrosses
  describe Game do
    let(:game) { Game.new }

    it 'placing a 0 on the grid' do
      game.place_nought_at(Point.middle)

      expect(game.print).to eq(<<~EXAMPLE
        -----
        |   |
        | 0 |
        |   |
        -----
      EXAMPLE
      )
    end

    it 'placing a 0 followed by an X' do
      game.place_nought_at(Point.middle)
        .place_cross_at(Point.middle_left)

      expect(game.print).to eq(<<~EXAMPLE
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
        game.place_nought_at(Point.middle)
          .place_cross_at(Point.bottom_middle)
          .place_nought_at(Point.middle_left)
          .place_cross_at(Point.bottom_right)
          .place_nought_at(Point.middle_right)

        expect(game).to be_over
      end

      it 'is over when there are 3 crosses vertically' do
        game.place_cross_at(Point.bottom_left)
          .place_nought_at(Point.bottom_middle)
          .place_cross_at(Point.middle_left)
          .place_nought_at(Point.middle)
          .place_cross_at(Point.top_left)

        expect(game).to be_over
      end
    end

    it 'is over when there are 3 crosses diagonally forward (/)' do
      game.place_cross_at(Point.bottom_left)
        .place_nought_at(Point.bottom_middle)
        .place_cross_at(Point.middle)
      game.place_nought_at(Point.bottom_right)
      game.place_cross_at(Point.top_right)

      expect(game).to be_over
    end

    it 'is over when there are 3 noughts diagonally backward (\)' do
      game.place_nought_at(Point.bottom_right)
        .place_cross_at(Point.bottom_middle)
        .place_nought_at(Point.middle)
        .place_cross_at(Point.bottom_left)
        .place_nought_at(Point.top_left)

      expect(game).to be_over
    end

    it 'is over when the grid is full but there is no winner' do
      game.place_nought_at(Point.top_middle)
        .place_cross_at(Point.bottom_left)
        .place_nought_at(Point.bottom_right)
        .place_cross_at(Point.middle_right)
        .place_nought_at(Point.middle)
        .place_cross_at(Point.bottom_middle)
        .place_nought_at(Point.top_right)
        .place_cross_at(Point.top_left)
        .place_nought_at(Point.middle_left)

      expect(game).to be_over
    end

    describe "rule violations" do
      it "doesn't allow two 0s to be placed consecutively" do
        game.place_nought_at(Point.middle)

        expect { game.place_nought_at(Point.top_right) }.to raise_error(NotYourTurnError)
      end

      it "doesn't allow two crosses to be placed consecutively" do
        game.place_cross_at(Point.middle)

        expect { game.place_cross_at(Point.top_left) }.to raise_error(NotYourTurnError)
      end

      it "doesn't allow marks in an occupied location" do
        game.place_cross_at(Point.middle)

        expect { game.place_nought_at(Point.middle) }.to raise_error(YouCantGoThereError)
      end

      it "doesn't allow marks in a location off the grid" do
        expect { game.place_cross_at(Point.new(20, 20)) }.to raise_error(YouCantGoThereError)
      end

      it "doesn't allow further moves when the game is over" do
        game.place_nought_at(Point.middle)
          .place_cross_at(Point.bottom_middle)
          .place_nought_at(Point.middle_left)
          .place_cross_at(Point.bottom_right)
          .place_nought_at(Point.middle_right)

        expect { game.place_cross_at(Point.top_left) }.to raise_error(YouCantGoThereError)
      end
    end
  end
end

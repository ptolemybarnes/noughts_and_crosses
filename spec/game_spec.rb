module NoughtsAndCrosses
  describe Game do
    let(:game) { Game.new }

    def nought_move(point)
      Move.new(point, Nought)
    end

    def cross_move(point)
      Move.new(point, Cross)
    end

    it 'placing a 0 on the grid' do
      game.play(nought_move(Point.middle))

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
      game.play(nought_move(Point.middle))
        .play(cross_move(Point.middle_left))

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
        game.play(nought_move(Point.middle))
          .play(cross_move(Point.bottom_middle))
          .play(nought_move(Point.middle_left))
          .play(cross_move(Point.bottom_right))
          .play(nought_move(Point.middle_right))

        expect(game).to be_over
      end

      it 'is over when there are 3 crosses vertically' do
        game.play(cross_move(Point.bottom_left))
          .play(nought_move(Point.bottom_middle))
          .play(cross_move(Point.middle_left))
          .play(nought_move(Point.middle))
          .play(cross_move(Point.top_left))

        expect(game).to be_over
      end
    end

    it 'is over when there are 3 crosses diagonally forward (/)' do
      game.play(cross_move(Point.bottom_left))
        .play(nought_move(Point.bottom_middle))
        .play(cross_move(Point.middle))
        .play(nought_move(Point.bottom_right))
        .play(cross_move(Point.top_right))

      expect(game).to be_over
    end

    it 'is over when there are 3 noughts diagonally backward (\)' do
      game.play(nought_move(Point.bottom_right))
        .play(cross_move(Point.bottom_middle))
        .play(nought_move(Point.middle))
        .play(cross_move(Point.bottom_left))
        .play(nought_move(Point.top_left))

      expect(game).to be_over
    end

    it 'is over when the grid is full but there is no winner' do
      game.play(nought_move(Point.top_middle))
        .play(cross_move(Point.bottom_left))
        .play(nought_move(Point.bottom_right))
        .play(cross_move(Point.middle_right))
        .play(nought_move(Point.middle))
        .play(cross_move(Point.bottom_middle))
        .play(nought_move(Point.top_right))
        .play(cross_move(Point.top_left))
        .play(nought_move(Point.middle_left))

      expect(game).to be_over
    end

    describe "rule violations" do
      it "doesn't allow two 0s to be placed consecutively" do
        game.play(nought_move(Point.middle))

        expect { game.play(nought_move(Point.top_right)) }.to raise_error(NotYourTurnError)
      end

      it "doesn't allow two crosses to be placed consecutively" do
        game.play(cross_move(Point.middle))

        expect { game.play(cross_move(Point.top_left)) }.to raise_error(NotYourTurnError)
      end

      it "doesn't allow marks in an occupied location" do
        game.play(cross_move(Point.middle))

        expect { game.play(nought_move(Point.middle)) }.to raise_error(YouCantGoThereError)
      end

      it "doesn't allow marks in a location off the grid" do
        expect { game.play(cross_move(Point.new(20, 20))) }.to raise_error(YouCantGoThereError)
      end

      it "doesn't allow further moves when the game is over" do
        game.play(nought_move(Point.middle))
          .play(cross_move(Point.bottom_middle))
          .play(nought_move(Point.middle_left))
          .play(cross_move(Point.bottom_right))
          .play(nought_move(Point.middle_right))

        expect { game.play(cross_move(Point.top_left)) }.to raise_error(YouCantGoThereError)
      end
    end
  end
end

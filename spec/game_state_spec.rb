module NoughtsAndCrosses
  describe GameState do
    subject(:game) { GameState.new }

    def nought_move(point)
      Move.new(point, Nought)
    end

    def cross_move(point)
      Move.new(point, Cross)
    end

    it 'placing a 0 on the grid' do
      new_game = game.play(nought_move(Point.middle))

      expect(new_game.print).to eq(<<~EXAMPLE
        -----
        |   |
        | 0 |
        |   |
        -----
      EXAMPLE
      )
    end

    it 'placing a X on the grid' do
      new_game = game.play(cross_move(Point.middle))

      expect(new_game.print).to eq(<<~EXAMPLE
        -----
        |   |
        | X |
        |   |
        -----
      EXAMPLE
      )
    end

    it 'placing a 0 on the grid' do
      new_game = game.play(nought_move(Point.middle))

      expect(new_game.print).to eq(<<~EXAMPLE
        -----
        |   |
        | 0 |
        |   |
        -----
      EXAMPLE
      )
    end

    describe 'Game Over!' do
      it 'is not over unless a player has 3 in a row' do
        expect(game).not_to be_over
      end

      it 'is won by Nought when she has 3 noughts horizontally' do
        game = create_game(<<~EXAMPLE
          -----
          |000|
          |XX |
          |   |
          -----
        EXAMPLE
        )

        expect(game).to be_won_by(Nought)
      end

      it 'is over when there are 3 crosses vertically' do
        game = create_game(<<~EXAMPLE
          -----
          | X0|
          | X |
          |0X |
          -----
        EXAMPLE
        )

        expect(game).to be_won_by(Cross)
      end
    end

    it 'is won by X when there are 3 Xs diagonally forward (/)' do
      game = create_game(<<~EXAMPLE
        -----
        | 0X|
        | X |
        |X0 |
        -----
      EXAMPLE
      )

      expect(game).to be_won_by(Cross)
    end

    it 'is over when there are 3 noughts diagonally backward (\)' do
      game = create_game(<<~EXAMPLE
        -----
        |0XX|
        | 0 |
        |XX0|
        -----
      EXAMPLE
      )

      expect(game).to be_won_by(Nought)
    end

    it 'is over when the grid is full but there is no winner' do
      game = create_game(<<~EXAMPLE
        -----
        |X0X|
        |X00|
        |0XX|
        -----
      EXAMPLE
      )

      expect(game).to be_over
    end

    describe 'rule violations' do
      it "doesn't allow marks in an occupied location" do
        new_game = game.play(cross_move(Point.middle))

        expect { new_game.play(nought_move(Point.middle)) }.to raise_error(YouCantGoThereError)
      end

      it "doesn't allow marks in a location off the grid" do
        expect { game.play(cross_move(Point.new(20, 20))) }.to raise_error(YouCantGoThereError)
      end

      it "doesn't allow further moves when the game is over" do
        game = create_game(<<~EXAMPLE
          -----
          |X0X|
          |X00|
          |0XX|
          -----
        EXAMPLE
        )


        expect do
          game.play(Move.new(Point.top_left, Nought))
        end.to raise_error(YouCantGoThereError)
      end
    end
  end
end

module NoughtsAndCrosses
  describe IdealMove do
    subject(:decision) { IdealMove }

    context 'when playing first' do
      it 'plays its first move in a corner' do
        game = create_game(<<~EXAMPLE
          -----
          |   |
          |   |
          |   |
          -----
        EXAMPLE
        )

        expect(decision.make(game, Nought)).to eq Move.new(Point.top_left, Nought)
      end

      context 'when opponent follows up with move in the center' do
        it 'makes its second move in the opposite corner' do
          game = create_game(<<~EXAMPLE
            -----
            |   |
            | 0 |
            |  X|
            -----
          EXAMPLE
          )

          expect(decision.make(game, Cross)).to eq Move.new(Point.top_left, Cross)
        end
      end

      it 'Nought goes for a winning move if available' do
        game = create_game(<<~EXAMPLE
          -----
          |0XX|
          |X0 |
          |0  |
          -----
        EXAMPLE
        )

        expect(decision.make(game, Nought)).to eq Move.new(Point.bottom_right, Nought)
      end

      it 'Cross goes for a winning move if available' do
        game = create_game(<<~EXAMPLE
          -----
          |00 |
          |0XX|
          |X0X|
          -----
        EXAMPLE
        )

        expect(decision.make(game, Cross)).to eq Move.new(Point.top_right, Cross)
      end

      it "blocks opponent if they're about to win" do
        game = create_game(<<~EXAMPLE
          -----
          | 0 |
          |0XX|
          |XX0|
          -----
        EXAMPLE
        )

        expect(decision.make(game, Nought)).to eq Move.new(Point.top_right, Nought)
      end

      it 'makes a splitting move when possible' do
        game = create_game(<<~EXAMPLE
          -----
          |0X |
          |X  |
          |0  |
          -----
        EXAMPLE
        )

        expect(decision.make(game, Nought)).to eq Move.new(Point.middle, Nought)
      end
    end

    context 'when playing second' do
      context 'when the opponent starts outside the center' do
        it 'makes its first move in the middle unless the opponent has done so' do
          game = create_game(<<~EXAMPLE
            -----
            |   |
            |   |
            |  X|
            -----
          EXAMPLE
          )

          expect(IdealMove.make(game, Nought)).to eq Move.new(Point.middle, Nought)
        end
      end

      context 'when the opponent starts in the middle' do
        it 'plays a corner move' do
          game = create_game(<<~EXAMPLE
            -----
            |   |
            | X |
            |   |
            -----
          EXAMPLE
          )

          expect(IdealMove.make(game, Nought)).to eq Move.new(Point.top_left, Nought)
        end
      end

      context "when the opponent tries a 'triangle split'" do
        it 'plays a side move' do
          game = create_game(<<~EXAMPLE
            -----
            |  X|
            | 0 |
            |X  |
            -----
          EXAMPLE
          )

          expect(IdealMove.make(game, Nought)).to eq Move.new(Point.top_middle, Nought)
        end
      end
    end
  end
end

module NoughtsAndCrosses
  describe MoveDecision do
    subject(:decision) { MoveDecision }

    context 'when playing first' do
      xit 'plays its first move in a corner' do
        grid = parse_grid(<<~EXAMPLE
          -----
          |   |
          |   |
          |   |
          -----
        EXAMPLE
        )

        corners = [
          Point.bottom_left, Point.top_right, Point.top_left, Point.bottom_right
        ].map {|point| Move.new(point, Nought) }

        expect(decision.make(grid, Nought)).to eq corners
      end

      context 'when opponent follows up with move in the center' do
        it 'makes its second move in the opposite corner' do
          grid = parse_grid(<<~EXAMPLE
            -----
            |   |
            | 0 |
            |  X|
            -----
          EXAMPLE
          )

          expect(decision.make(grid, Cross)).to eq Move.new(Point.top_left, Cross)
        end
      end

      it 'Nought goes for a winning move if available' do
        grid = parse_grid(<<~EXAMPLE
          -----
          |0XX|
          |X0 |
          |0  |
          -----
        EXAMPLE
        )

        expect(decision.make(grid, Nought)).to eq Move.new(Point.bottom_right, Nought)
      end

      it 'Cross goes for a winning move if available' do
        grid = parse_grid(<<~EXAMPLE
          -----
          |00 |
          |0XX|
          |X0X|
          -----
        EXAMPLE
        )

        expect(decision.make(grid, Cross)).to eq Move.new(Point.top_right, Cross)
      end

      it "blocks opponent if they're about to win" do
        grid = parse_grid(<<~EXAMPLE
          -----
          | 0 |
          |0XX|
          |XX0|
          -----
        EXAMPLE
        )

        expect(decision.make(grid, Nought)).to eq Move.new(Point.top_right, Nought)
      end

      it 'makes a splitting move when possible' do
        grid = parse_grid(<<~EXAMPLE
          -----
          |0X |
          |X  |
          |0  |
          -----
        EXAMPLE
        )

        expect(decision.make(grid, Nought)).to eq Move.new(Point.middle, Nought)
      end
    end

    context 'when playing second' do
      context "when the opponent starts outside the center" do
        it "makes its first move in the middle unless the opponent has done so" do
          grid = parse_grid(<<~EXAMPLE
            -----
            |   |
            |   |
            |  X|
            -----
          EXAMPLE
          )

          expect(MoveDecision.make(grid, Nought)).to eq Move.new(Point.middle, Nought)
        end
      end

      context "when the opponent starts in the middle" do
        xit "plays a corner move" do
          grid = parse_grid(<<~EXAMPLE
            -----
            |   |
            | X |
            |   |
            -----
          EXAMPLE
          )

          expect(MoveDecision.make(grid, Nought)).to eq Move.new(Point.top_right, Nought)
        end
      end

      context "when the opponent tries a 'triangle split'" do
        it "plays a side move" do
          grid = parse_grid(<<~EXAMPLE
            -----
            |  X|
            | 0 |
            |X  |
            -----
          EXAMPLE
          )

          expect(MoveDecision.make(grid, Nought)).to eq Move.new(Point.top_middle, Nought)
        end
      end
    end

    def parse_grid(grid)
      moves_list = grid.scan(/[0X ]/).each_slice(3).to_a.reverse.map.with_index do |row, y|
        row.map.with_index do |mark_string, x|
          mark = [NullMark, Nought, Cross].find {|mark| mark.to_s == mark_string }
          Move.new(Point.new(x, y), mark)
        end
      end.flatten(1).reject {|move| move.mark.null_mark? }
      Grid.new(MovesList.new(moves_list))
    end
  end
end

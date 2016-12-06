require 'pry'
require './lib/move'
require './lib/move_decision'
require './lib/point'
require './lib/game'
require './lib/moves_list'
require './lib/mark'
require './lib/grid'
require './lib/move_decision_strategy'

module NoughtsAndCrosses
  describe MoveDecision do
    subject(:decision) { MoveDecision }

    describe 'winning when playing first' do
      it 'plays its first move in a corner' do
        grid = parse_grid(<<~EXAMPLE
          -----
          |   |
          |   |
          |   |
          -----
        EXAMPLE
        )

        expect(decision.make(grid, Nought)).to eq Move.new(Point.bottom_left, Nought)
      end

      context 'when opponent follows up with move outside center' do
        it 'makes its second move in either adjacent corner' do
          grid = parse_grid(<<~EXAMPLE
            -----
            | 0 |
            |   |
            |X  |
            -----
          EXAMPLE
          )

          expect(decision.make(grid, Cross)).to eq Move.new(Point.top_left, Cross)
        end

        context 'the follow-up move is in an adjacent corner' do
          it 'makes its second move in the other adjacent corner' do
            grid = parse_grid(<<~EXAMPLE
              -----
              |0  |
              |   |
              |X  |
              -----
            EXAMPLE
            )

            expect(decision.make(grid, Cross)).to eq Move.new(Point.bottom_right, Cross)
          end
        end
      end

      context 'when opponent follows up with move in the center' do
        it 'makes its second move in the opposite corner' do
          grid = parse_grid(<<~EXAMPLE
            -----
            |   |
            | 0 |
            |X  |
            -----
          EXAMPLE
          )

          expect(decision.make(grid, Cross)).to eq Move.new(Point.top_right, Cross)
        end
      end

      it 'goes for a winning move if available' do
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

      it "blocks opponent if they're about to win" do
        grid = parse_grid(<<~EXAMPLE
          -----
          |0X |
          |X  |
          |00 |
          -----
        EXAMPLE
        )

        expect(decision.make(grid, Cross)).to eq Move.new(Point.bottom_right, Cross)
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

      def parse_grid(grid)
        moves_list = grid.scan(/[0X ]/).each_slice(3).to_a.reverse.map.with_index do |row, y|
          row.map.with_index do |mark_string, x|
            mark = [NullMark, Nought, Cross].find {|mark| mark.to_s == mark_string }
            Move.new(Point.new(x, y), mark)
          end
        end.flatten(1)
        Grid.new(MovesList.new(moves_list))
      end
    end
  end
end

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

    context 'when playing first' do
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
        it 'makes a move that leads to a split' do
          grid = parse_grid(<<~EXAMPLE
            -----
            | 0 |
            |   |
            |X  |
            -----
          EXAMPLE
          )

          tempo_gaining_moves = [
            Point.top_left, Point.bottom_right
          ].map {|point| Move.new(point, Cross) }

          expect(tempo_gaining_moves).to include decision.make(grid, Cross)
        end

        context 'the follow-up move is in an adjacent corner' do
          it 'makes its second move to set up a splitting move' do
            grid = parse_grid(<<~EXAMPLE
              -----
              |0  |
              |   |
              |X  |
              -----
            EXAMPLE
            )

            expect(decision.make(grid, Cross)).to eq Move.new(Point.top_right, Cross)
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

      it 'plays any available move if no good moves are available' do
        grid = parse_grid(<<~EXAMPLE
          -----
          |X0 |
          |0X |
          |0X0|
          -----
        EXAMPLE
        )

        available_moves = [
          Move.new(Point.top_right, Cross), Move.new(Point.middle_right, Cross)
        ]
        expect(available_moves).to include decision.make(grid, Cross)
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
        it "plays a corner move" do
          grid = parse_grid(<<~EXAMPLE
            -----
            |   |
            | X |
            |   |
            -----
          EXAMPLE
          )

          corner_moves = [
            Point.top_left, Point.top_right, Point.bottom_left, Point.bottom_right
          ].map {|point| Move.new(point, Nought) }
          expect(corner_moves).to include MoveDecision.make(grid, Nought)
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

          side_moves = [
            Point.top_middle, Point.middle_left, Point.middle_right, Point.bottom_middle
          ].map {|point| Move.new(point, Nought) }
          expect(side_moves).to include MoveDecision.make(grid, Nought)
        end
      end
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

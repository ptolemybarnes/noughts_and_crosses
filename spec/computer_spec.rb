require 'pry'
require './lib/computer'
require './lib/point'
require './lib/game'
require './lib/moves_list'
require './lib/mark'
require './lib/grid'

module NoughtsAndCrosses
  describe Computer do
    subject(:computer) { Computer.new }

    TOP_LEFT      = Point.new(0, 2)
    TOP_MIDDLE    = Point.new(1, 2)
    TOP_RIGHT     = Point.new(2, 2)
    MIDDLE_LEFT   = Point.new(0, 1)
    MIDDLE        = Point.new(1, 1)
    MIDDLE_RIGHT  = Point.new(2, 1)
    BOTTOM_LEFT   = Point.new(0, 0)
    BOTTOM_MIDDLE = Point.new(1, 0)
    BOTTOM_RIGHT  = Point.new(2, 0)

    describe 'a winning sequence' do
      it 'plays its first move in a corner' do
        grid = create_grid(<<~EXAMPLE
          -----
          |   |
          |   |
          |   |
          -----
        EXAMPLE
        )

        expect(computer.decide_move(grid)).to eq BOTTOM_LEFT
      end

      def create_grid(grid)
        moves_list = grid.scan(/[0X ]/).each_slice(3).to_a.reverse.map.with_index do |row, y|
          row.map.with_index do |mark_string, x|
            mark = [NullMark, Nought, Cross].find {|mark| mark.to_s == mark_string }
            [ Point.new(x, y), mark ]
          end
        end.flatten(1).to_h
        Grid.new(MovesList.new(moves_list))
      end

      it 'makes its second move in an adjacent corner' do
        grid = create_grid(<<~EXAMPLE
          -----
          | X |
          |   |
          |0  |
          -----
        EXAMPLE
        )

        expect(computer.decide_move(grid)).to eq TOP_LEFT
      end

      it 'goes for a winning move if available' do
        grid = create_grid(<<~EXAMPLE
          -----
          |0XX|
          |X0 |
          |0  |
          -----
        EXAMPLE
        )

        expect(computer.decide_move(grid)).to eq BOTTOM_RIGHT
      end
      it 'makes its last move to win the game'
    end
  end
end

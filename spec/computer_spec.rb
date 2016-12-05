require './lib/computer'
require './lib/point'
require './lib/moves_list'

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
        expect(computer.decide_move(MovesList.new({}))).to eq BOTTOM_LEFT
      end

      it 'makes its second move in an adjacent corner' do
        moves = {
          BOTTOM_LEFT => '0',
          TOP_MIDDLE => 'X'
        }

        expect(computer.decide_move(MovesList.new(moves))).to eq TOP_LEFT
      end

      it 'makes its third move in the middle' do
        moves = {
          BOTTOM_LEFT => '0',
          TOP_MIDDLE  => 'X',
          TOP_LEFT    => '0',
          MIDDLE_LEFT => 'X'
        }

        expect(computer.decide_move(moves)).to eq MIDDLE
      end

      it 'makes its last move to win the game' do
        moves = {
          BOTTOM_LEFT => '0',
          TOP_MIDDLE  => 'X',
          TOP_LEFT    => '0',
          MIDDLE_LEFT => 'X',
          MIDDLE      => '0',
          TOP_RIGHT   => 'X'
        }

        expect(computer.decide_move(MovesList.new(moves))).to eq BOTTOM_RIGHT
      end
    end
  end
end

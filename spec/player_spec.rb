require 'pry'
module NoughtsAndCrosses
  describe 'Players' do
    let(:input_channel)  { instance_double(IO, gets: '1, 1') }
    let(:grid) { instance_double(Grid, print: '') }

    describe CommandLinePlayer do
      let(:human_player) do
        CommandLinePlayer.new(Nought, input: input_channel)
      end

      it 'takes the coordinates of a point "x, y" and creates a move' do
        allow(input_channel).to receive(:gets).and_return('0, 0')

        expect(human_player.get_move(grid)).to eq Move.new(Point.new(0, 0), Nought)
      end

      it 'allows coordinates without a seperating space' do
        allow(input_channel).to receive(:gets).and_return('0,0')

        expect(human_player.get_move(grid)).to eq Move.new(Point.new(0, 0), Nought)
      end

      describe 'validations' do
        it 'validates that the input received is coordinates x & y' do
          allow(input_channel).to receive(:gets).and_return('0')

          expect { human_player.get_move(grid) }.to raise_error InvalidInputError
        end

        it 'validates that the input received is a number x & y' do
          allow(input_channel).to receive(:gets).and_return('0, j')

          expect { human_player.get_move(grid) }.to raise_error InvalidInputError
        end
      end
    end

    describe ComputerPlayer do
      let(:computer_player) do
        ComputerPlayer.new(Nought, input: input_channel)
      end

      it 'gets a move from IdealMove' do
        allow(IdealMove).to receive(:make).with(grid, Nought).and_return(:move)

        expect(computer_player.get_move(grid)).to eq :move
      end
    end
  end
end

require 'pry'
module NoughtsAndCrosses
  describe 'Players' do
    let(:input_channel)  { instance_double(IO, gets: '1, 1') }
    let(:output_channel) { instance_double(IO, puts: nil) }
    let(:grid) { instance_double(Grid, print: '') }

    before do
      allow(output_channel).to receive(:puts)
    end

    describe HumanPlayer do
      let(:human_player) do
        HumanPlayer.new(Nought, input: input_channel, output: output_channel)
      end

      it 'takes the coordinates of a point and creates a move' do
        allow(input_channel).to receive(:gets).and_return('0, 0')

        expect(human_player.get_move(grid)).to eq Move.new(Point.new(0, 0), Nought)
      end

      it 'validates that the input received is a possible point location' do
        allow(input_channel).to receive(:gets).and_return('0')

        expect { human_player.get_move(grid) }.to raise_error InvalidInputError
      end

      it 'prints the grid and sends it to the output channel' do
        allow(grid).to receive(:print).and_return(:grid_representation)

        human_player.get_move(grid)

        expect(output_channel).to have_received(:puts).with(:grid_representation)
      end
    end

    describe ComputerPlayer do
      let(:computer_player) do
        ComputerPlayer.new(Nought, input: input_channel, output: output_channel)
      end

      it 'gets a move from IdealMove' do
        allow(IdealMove).to receive(:make).with(grid, Nought).and_return(:move)

        expect(computer_player.get_move(grid)).to eq :move
      end
    end
  end
end

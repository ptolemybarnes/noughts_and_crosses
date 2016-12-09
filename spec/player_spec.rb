module NoughtsAndCrosses
  describe 'Players' do
    let(:input_channel)  { instance_double(IO) }
    let(:output_channel) { instance_double(IO, puts: nil) }
    let(:grid) { instance_double(Grid, print: '') }

    describe HumanPlayer do
      it "takes the coordinates of a point and creates a move" do
        allow(input_channel).to receive(:gets).and_return('0, 0')

        player = HumanPlayer.new(Nought, input: input_channel, output: output_channel)

        expect(player.get_move(grid)).to eq Move.new(Point.new(0, 0), Nought)
      end

      it "checks that the input received is a possible point location" do
        allow(input_channel).to receive(:gets).and_return('0')

        player = HumanPlayer.new(Nought, input: input_channel, output: output_channel)

        expect { player.get_move(grid) }.to raise_error InvalidInputError
      end
    end

    describe ComputerPlayer do

      it "gets a move from MoveDecision" do
        allow(MoveDecision).to receive(:sample).with(grid, Nought).and_return(:move)

        player = ComputerPlayer.new(Nought, input: input_channel, output: output_channel)

        expect(player.get_move(grid)).to eq :move
      end
    end
  end
end

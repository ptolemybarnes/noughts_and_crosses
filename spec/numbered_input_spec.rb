module NoughtsAndCrosses
  describe NumberedInput do

    def change_cell_to_coordinate(cell_number)
      NumberedInput.new(double(:input, gets: cell_number)).gets
    end

    it { expect(change_cell_to_coordinate('1')).to eq '0, 2' }
    it { expect(change_cell_to_coordinate('2')).to eq '1, 2' }
    it { expect(change_cell_to_coordinate('3')).to eq '2, 2' }
    it { expect(change_cell_to_coordinate('4')).to eq '0, 1' }
    it { expect(change_cell_to_coordinate('5')).to eq '1, 1' }
    it { expect(change_cell_to_coordinate('6')).to eq '2, 1' }
    it { expect(change_cell_to_coordinate('7')).to eq '0, 0' }
    it { expect(change_cell_to_coordinate('8')).to eq '1, 0' }
    it { expect(change_cell_to_coordinate('9')).to eq '2, 0' }

    it 'raises an invalid input error if the input is not a digit' do
      expect { change_cell_to_coordinate('abc') }.to raise_error(InvalidInputError)
    end
  end
end

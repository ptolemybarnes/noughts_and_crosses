require './lib/computer'
require './lib/point'

module NoughtsAndCrosses
  describe Computer do
    subject(:computer) { Computer.new }

    it 'plays its first move in a corner' do
      expect(computer.decide_move({})).to eq Point.new(0, 0)
    end
  end
end

module NoughtsAndCrosses

  describe 'A game of noughts and crosses' do

    it 'placing a 0 on the grid' do
      game = Game.new
      game.place_nought_at(:center)

      expect(game.print_grid).to eq(<<~EXAMPLE
        _____
        |   |
        | 0 |
        |   |
        -----
      EXAMPLE
      )
    end
  end

end

module NoughtsAndCrosses

  class Game

    def place_nought_at(location)
    end

    def print_grid
      <<~EXAMPLE
        _____
        |   |
        | 0 |
        |   |
        -----
      EXAMPLE
    end

  end

end


module NoughtsAndCrosses
  describe GainTempoMoves do
    subject(:gain_tempo_moves) { described_class }

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
        Point.top_left, Point.middle, Point.bottom_right
      ].map {|point| Move.new(point, Cross) }
      expect(gain_tempo_moves.make(grid, Cross)).to eq tempo_gaining_moves
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

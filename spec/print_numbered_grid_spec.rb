module NoughtsAndCrosses
  describe PrintNumberedGrid do

    it 'numbers the empty cells' do
      grid = <<~EXAMPLE
        -----
        | 0 |
        |X  |
        | 0 |
        -----
      EXAMPLE

      expect(PrintNumberedGrid.call(grid.chars)).to eq(<<~EXAMPLE
        -----
        |103|
        |X56|
        |709|
        -----
      EXAMPLE
      )
    end
  end
end

module NoughtsAndCrosses
  class PrintNumberedGrid
    attr_reader :grid

    def self.call(grid)
      new(grid).call
    end

    def initialize(grid)
      @grid = grid
    end

    def call
      PrintGrid.call(grid).gsub(/[X0 ]/).with_index {|char, index| char == " " ? index.next : char }
    end
  end
end

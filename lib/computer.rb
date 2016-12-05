module NoughtsAndCrosses
  class Computer
    def decide_move(grid)
      return Point.new(0, 0) if grid.empty?
      Point.new(0, 2)
    end
  end
end

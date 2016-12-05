module NoughtsAndCrosses
  class Computer
    def decide_move(grid)
      return Point.new(0, 0) if grid.empty?
      return winning_move(grid) if winning_move(grid)
      Point.new(0, 2)
    end

    def winning_move(grid)
      winning_line = grid.each_line.find do |line|
        line.select do |point, mark|
          mark == Nought
        end.length == 2 && line.none? {|point, mark| mark == Cross }
      end
      return false if winning_line.nil?
      winning_line.find {|point, mark| mark.null_mark? }.first
    end
  end
end

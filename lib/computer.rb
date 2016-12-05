module NoughtsAndCrosses
  class Computer
    def decide_move(grid)
      return Point.new(0, 0) if grid.empty?
      return winning_move if winning_move(moves_list)
      turn_number = moves_list.length
      if turn_number == 2
        Point.new(0, 2)
      else
        Point.new(1, 1)
      end
    end

    def winning_move(moves_list)
      mark = moves_list.next_move
      moves_list.each_line do |location, content|
        puts content
      end
      false
    end
  end
end

module NoughtsAndCrosses
  class Computer
    def decide_move(moves_list)
      if moves_list.empty?
        Point.new(0, 0)
      else
        Point.new(0, 2)
      end
    end
  end
end

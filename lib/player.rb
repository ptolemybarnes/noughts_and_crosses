module NoughtsAndCrosses
  class Player
    def initialize(mark, input: STDIN, output: STDOUT)
      @mark   = mark
      @input  = input
      @output = output
    end
    private

    attr_reader :mark, :input, :output
  end


  class HumanPlayer < Player
    def get_move(grid)
      output.puts grid.print
      move_points = get_user_input
      Move.new(Point.new(*move_points), mark)
    end

    private

    def get_user_input
      move_points = input.gets.chomp
      raise InvalidInputError.new(move_points) unless valid_possible_point?(move_points)
      move_points.split(', ').map(&:to_i)
    end

    def valid_possible_point?(move_points)
      move_points.match(/^\d,\s?\d$/)
    end
  end

  class ComputerPlayer < Player
    def get_move(grid)
      output.puts grid.print
      IdealMove.make(grid, mark)
    end
  end

  class InvalidInputError < StandardError; end
end

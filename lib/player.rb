module NoughtsAndCrosses
  class Player
    def initialize(mark, input: STDIN, output: STDOUT)
      @mark   = mark
      @input  = input
      @output = output
    end

    def get_move(game)
    end

    private

    attr_reader :mark, :input, :output
  end

  class CommandLinePlayer < Player
    def get_move(grid)
      move_points = get_user_input
      Move.new(Point.new(*move_points), mark)
    end

    private

    def get_user_input
      move_points = input.gets.chomp
      move_points.split(', ').map(&:to_i)
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

module NoughtsAndCrosses
  class Player
    attr_accessor :mark

    def initialize(mark = nil, input: STDIN)
      @mark  = mark
      @input = input
    end

    def get_move(game)
    end

    def ready?
      !mark.nil?
    end

    private

    attr_reader :input
  end

  class CommandLinePlayer < Player
    def get_move(grid)
      move_points = get_user_input
      Move.new(Point.new(*move_points), mark)
    end

    private

    def get_user_input
      move_points = input.gets.chomp
      raise InvalidInputError unless move_points.match(/\d,\s?\d/)
      move_points = move_points.scan(/\d/).map(&:to_i)
      raise InvalidInputError unless move_points.count == 2
      move_points
    end
  end

  class ComputerPlayer < Player
    def get_move(grid)
      IdealMove.make(grid, mark)
    end
  end

  class InvalidInputError < StandardError; end
end

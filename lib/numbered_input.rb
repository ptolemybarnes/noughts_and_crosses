module NoughtsAndCrosses
  class NumberedInput

    def initialize(input = STDIN)
      @input = input
    end

    def gets
      cell_number_input = input.gets
      raise InvalidInputError unless cell_number_input.match(/\d/)
      cell_number = cell_number_input.to_i
      y = (((cell_number - 1) / 3) - 3).abs - 1
      x = ((cell_number  - 1) % 3).abs
      "#{x}, #{y}"
    end

    private

    attr_reader :input
  end
end

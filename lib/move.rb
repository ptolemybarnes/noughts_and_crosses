# value object representing the placing of a mark at a particular point
module NoughtsAndCrosses
  class Move
    attr_reader :point, :mark

    def initialize(point, mark)
      @point, @mark = point, mark
    end

    def ==(other)
      other == [point, mark]
    end
  end
end

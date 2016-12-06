module NoughtsAndCrosses
  class Point
    attr_reader :x, :y

    def initialize(x, y)
      @x, @y = x, y
    end

    def self.all
      [
        top_left, top_middle, top_right,
        middle_left, middle, middle_right,
        bottom_left, bottom_middle, bottom_right
      ]
    end

    def ==(other)
      other == [x, y]
    end

    def self.top_left
      new(0, 2)
    end

    def self.top_middle
      new(1, 2)
    end

    def self.top_right
      new(2, 2)
    end

    def self.middle_left
      new(0, 1)
    end

    def self.middle
      new(1, 1)
    end

    def self.middle_right
      new(2, 1)
    end

    def self.bottom_left
      new(0, 0)
    end

    def self.bottom_middle
      new(1, 0)
    end

    def self.bottom_right
      new(2, 0)
    end
  end
end

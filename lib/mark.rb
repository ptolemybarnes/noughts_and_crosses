module NoughtsAndCrosses
  class Nought
    def self.null_mark?
      false
    end

    def self.to_s
      '0'
    end

    def self.opponent
      Cross
    end
  end

  class Cross
    def self.null_mark?
      false
    end

    def self.to_s
      'X'
    end

    def self.opponent
      Nought
    end
  end

  class NullMark
    def self.null_mark?
      true
    end

    def self.to_s
      ' '
    end

    def self.opponent
      self
    end
  end
end

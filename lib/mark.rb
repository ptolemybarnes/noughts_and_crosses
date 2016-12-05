module NoughtsAndCrosses
  class Nought
    def self.null_mark?
      false
    end

    def self.to_s
      '0'
    end
  end

  class Cross
    def self.null_mark?
      false
    end

    def self.to_s
      'X'
    end
  end

  class NullMark
    def self.null_mark?
      true
    end

    def self.to_s
      ' '
    end
  end
end

# distinguish the three different kinds of marks and their relationships.
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
  end
end

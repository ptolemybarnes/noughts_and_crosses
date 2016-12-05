module NoughtsAndCrosses
  class Nought
    def self.null_mark?
      false
    end
  end

  class Cross
    def self.null_mark?
      false
    end
  end

  class NullMark
    def self.null_mark?
      true
    end
  end
end

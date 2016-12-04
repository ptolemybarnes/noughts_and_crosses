module NoughtsAndCrosses
  class MovesList

    def initialize(moves = {})
      @moves = moves
    end

    def add(location, content)
      raise YouCantGoThereError if moves[location]
      raise NotYourTurnError if !empty? && last[1] == content
      moves[location] = content
    end

    def fetch(key, default = nil)
      moves.fetch(key, default)
    end

    def length
      moves.length
    end

    def each_row
      LOCATIONS.each_slice(3).map do |row|
        row.map {|location| fetch(location) }
      end.to_enum
    end

    def each_column
      rotate(LOCATIONS.each_slice(3).to_a).map do |row|
        row.map {|location| fetch(location) }
      end.to_enum
    end

    def full?
      LOCATIONS.map {|location| fetch(location) }.all?
    end

    def dup
      self.class.new(moves.dup)
    end

    def empty?
      moves.empty?
    end

    private

    attr_reader :moves

    def rotate(two_dimensional_array)
      two_dimensional_array.inject {|sum, row| sum.zip(row) }.map(&:flatten)
    end

    def last
      moves.to_a.last
    end
  end
end

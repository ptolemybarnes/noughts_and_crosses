module NoughtsAndCrosses
  class PrintGrid

    def initialize(rows)
      @rows = rows
    end

    def self.call(rows)
      new(rows).call
    end

    def call
      "-----\n|" +
        rows.map do |row|
        row.map { |move| move.mark.to_s }
      end.map(&:join).join("|\n|") +
      "|\n-----\n"
    end

    private

    attr_reader :rows
  end
end

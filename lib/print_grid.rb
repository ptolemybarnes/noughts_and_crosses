module NoughtsAndCrosses
  class PrintGrid

    def initialize(rows)
      @rows = rows
    end

    def self.call(rows)
      new(rows).call
    end

    def call
      rows.join
    end

    private

    attr_reader :rows
  end
end

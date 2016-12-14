module NoughtsAndCrosses
  class RankCache
    def initialize
      @cache = {}
    end

    def fetch(game, next_mark)
      hash = [game.print, next_mark].hash
      if @cache[hash]
        return @cache[hash]
      end
      result = yield
      @cache[hash] = result
      result
    end
  end
end

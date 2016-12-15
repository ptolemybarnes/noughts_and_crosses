# caches the rank of a given game scenario
module NoughtsAndCrosses
  class RankCache
    def initialize
      @cache = {}
    end

    def fetch(game, next_mark)
      hash = [game.print, next_mark].hash
      return cache[hash] if cache[hash]
      rank = yield
      cache[hash] = rank
    end

    private

    attr_reader :cache
  end
end

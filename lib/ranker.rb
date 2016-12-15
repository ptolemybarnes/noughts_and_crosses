# ranks a game according to whether it was won by a given mark
module NoughtsAndCrosses
  class Ranker
    WINNING_RANK = 1
    LOSING_RANK  = -1
    DRAWING_RANK = 0

    def initialize(mark)
      @max_mark = mark
    end

    def call(game)
      if game.won_by?(@max_mark)
        WINNING_RANK
      elsif game.won_by?(@max_mark.opponent)
        LOSING_RANK
      else
        DRAWING_RANK
      end
    end
  end
end

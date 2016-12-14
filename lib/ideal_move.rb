module NoughtsAndCrosses
  class IdealMove
    class RankedMove < Struct.new(:rank, :move); end

    def self.make(grid, mark)
      return Move.new(Point.top_left, mark) if grid.empty?
      new(mark).make(Game.new(grid), mark).move
    end

    def initialize(mark)
      @max    = mark
      @min    = mark.opponent
      @ranker = Ranker.new(mark)
    end

    def make(game, mark)
      find_max(minimax(possible_games(game, mark), mark.opponent))
    end

    private

    def possible_games(game, mark)
      PossibleGames.make(game.grid, mark)
    end

    def minimax(possible_games, next_mark)
      possible_games.lazy.map do |possible_game, move|
        rank = determine_rank_of(possible_game, next_mark)
        RankedMove.new(rank, move)
      end
    end

    def determine_rank_of(game, next_mark)
      rank_cache.fetch(game, next_mark) do
        _determine_rank_of(game, next_mark)
      end
    end

    def _determine_rank_of(game, next_mark)
      if game.over?
        @ranker.call(game)
      else
        if next_mark == @max
          find_max(minimax(possible_games(game, next_mark), next_mark.opponent)).rank
        else
          find_min(minimax(possible_games(game, next_mark), next_mark.opponent)).rank
        end
      end
    end

    def find_max(enum)
      take_until_rank(enum, 1).max_by(&:rank)
    end

    def find_min(enum)
      take_until_rank(enum, -1).min_by(&:rank)
    end

    def take_until_rank(enum, break_condition)
      ranks = []
      enum.each do |ranked_move|
        ranks << ranked_move
        break if ranked_move.rank == break_condition
      end
      ranks
    end

    def rank_cache
      @cache ||= RankCache.new
    end
  end

  class Ranker
    def initialize(mark)
      @top_mark = mark
    end

    def call(game)
      if game.won_by?(@top_mark)
        1
      elsif game.won_by?(@top_mark.opponent)
        -1
      else
        0
      end
    end
  end
end

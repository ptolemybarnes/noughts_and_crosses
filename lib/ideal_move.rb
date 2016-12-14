module NoughtsAndCrosses
  class IdealMove
    class RankedMove < Struct.new(:rank, :move); end

    def self.make(grid, mark)
      return Move.new(Point.top_left, mark) if grid.empty?
      new(mark).make(Game.new(grid), mark).move
    end

    def initialize(mark)
      @max_mark = mark
      @ranker   = Ranker.new(mark)
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
        if next_mark == @max_mark
          find_max(minimax(possible_games(game, next_mark), next_mark.opponent)).rank
        else
          find_min(minimax(possible_games(game, next_mark), next_mark.opponent)).rank
        end
      end
    end

    def find_max(rankable_moves)
      rank_until(rankable_moves, Ranker::WINNING_RANK).max_by(&:rank)
    end

    def find_min(rankable_moves)
      rank_until(rankable_moves, Ranker::LOSING_RANK).min_by(&:rank)
    end

    def rank_until(rankable_moves, max_or_min_rank_limit)
      rankable_moves.each_with_object([]) do |rankable_move, ranked_moves|
        ranked_moves << rankable_move
        return ranked_moves if rankable_move.rank == max_or_min_rank_limit
      end
    end

    def rank_cache
      @cache ||= RankCache.new
    end
  end
end

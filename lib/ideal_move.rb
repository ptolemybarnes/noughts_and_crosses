module NoughtsAndCrosses
  class IdealMove
    class RankedMove < Struct.new(:rank, :move); end

    def self.make(game_state, mark)
      return Move.new(Point.top_left, mark) if game_state.grid.empty?
      new(mark).make(game_state, mark).move
    end

    def initialize(mark)
      @max_mark = mark
      @ranker   = Ranker.new(mark)
    end

    def make(game_state, mark)
      find_max(minimax(game_state.possible_states(mark), mark.opponent))
    end

    private

    def minimax(possible_game_states, next_mark)
      possible_game_states.lazy.map do |possible_game_state, move|
        rank = determine_rank_of(possible_game_state, next_mark)
        RankedMove.new(rank, move)
      end
    end

    def determine_rank_of(game_state, next_mark)
      rank_cache.fetch(game_state, next_mark) do
        _determine_rank_of(game_state, next_mark)
      end
    end

    def _determine_rank_of(game_state, next_mark)
      if game_state.over?
        @ranker.call(game_state)
      else
        if next_mark == @max_mark
          find_max(minimax(game_state.possible_states(next_mark), next_mark.opponent)).rank
        else
          find_min(minimax(game_state.possible_states(next_mark), next_mark.opponent)).rank
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

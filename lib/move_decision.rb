module NoughtsAndCrosses
  class MoveDecision

    def self.make(grid, mark)
      return Move.new(Point.top_left, mark) if grid.empty?
      IdealMove.make(Game.new(grid), mark)
    end

  end

  class IdealMove

    def self.make(game, mark)
      new(mark).make(game, mark)[1]
    end

    def initialize(mark)
      @max    = mark
      @min    = mark.opponent
      @ranker = Ranker.new(mark)
    end

    def make(game, mark)
      minimax(possible_games(game, mark), mark.opponent).max_by {|rank, move| rank }
    end

    def possible_games(game, mark)
      PossibleGames.make(game.grid, mark)
    end

    class RankedMove < Struct.new(:rank, :move); end


    def minimax(possible_games, next_mark)
      possible_games.map do |game, move|
        if game.over?
          [ @ranker.call(game), move ]
        else
          strategy = (next_mark == @max ? :max : :min)
          [ minimax(possible_games(game, next_mark), next_mark.opponent).map {|rank, move| rank }.send(strategy), move ]
        end
      end
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

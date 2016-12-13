module NoughtsAndCrosses
  class MoveDecision

    def self.make(grid, mark)
      IdealMove.make(grid, mark)
    end

  end

  class IdealMove

    def self.make(grid, mark)
      new(mark).make(grid, mark)[1]
    end

    def initialize(mark)
      @max = mark
      @min = mark.opponent
    end

    def make(grid, mark)
      minimax(possible_grids(grid, mark), mark.opponent).max_by {|rank, move| rank }
    end

    def possible_grids(grid, mark)
      PossibleMoves.make(grid, mark).map do |move|
        [ grid.add(move), move ]
      end
    end

    class RankedMove < Struct.new(:rank, :move); end


    def minimax(grids_and_moves, next_mark)
      grids_and_moves.map do |grid, move|
        game = Game.new(grid)
        if game.over?
          [ rank(game), move ]
        elsif next_mark == @max
          [ minimax(possible_grids(grid, next_mark), next_mark.opponent).map {|rank, move| rank }.max, move ]
        elsif next_mark == @min
          [ minimax(possible_grids(grid, next_mark), next_mark.opponent).map {|rank, move| rank }.min, move ]
        else
          raise 'we have a problem'
        end
      end
    end

    def rank(game)
      if game.won_by?(@max)
        1
      elsif game.won_by?(@min)
        -1
      else
        0
      end
    end
  end
end

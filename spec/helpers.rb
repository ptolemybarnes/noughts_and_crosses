module Helpers
  include NoughtsAndCrosses

  def create_game(grid)
    GameState.new(create_grid(grid))
  end

  def create_grid(grid)
    moves_list = grid.scan(/[0X ]/).each_slice(3).to_a.reverse.map.with_index do |row, y|
      row.map.with_index do |mark_string, x|
        mark = [NullMark, Nought, Cross].find { |mark| mark.to_s == mark_string }
        Move.new(Point.new(x, y), mark)
      end
    end.flatten(1).reject { |move| move.mark.null_mark? }
    Grid.new(moves: MovesList.new(moves_list))
  end
end

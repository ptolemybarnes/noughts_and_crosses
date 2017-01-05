module NoughtsAndCrosses
  class Game
    def initialize(first_player, second_player, events = {}, game_state = GameState.new)
      @players    = [ first_player, second_player ].cycle
      @events     = Hash.new { Proc.new {} }.merge(events)
      @game_state = game_state
    end

    def self.run(*args)
      game = new(*args)
      until game.over?
        game.run
      end
    end

    def run
      begin
        _run
      rescue YouCantGoThereError => e
        events[:invalid_move].call(game_state, e)
      rescue InvalidInputError => e
        events[:invalid_input].call(game_state, e)
      end
    end

    def over?
      game_state.over?
    end

    private

    attr_reader :players, :game_state, :events

    def _run
      if start_event = events[:game_start]
        start_event.call(game_state)
        events[:game_start] = nil
      end
      move = players.peek.get_move(game_state)
      @game_state = game_state.play(move)
      if game_state.over?
        events[:game_over].call(game_state)
      else
        events[:turn_change].call(game_state)
        players.next
      end
      self
    end
  end
end

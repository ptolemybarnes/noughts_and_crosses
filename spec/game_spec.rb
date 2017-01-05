module NoughtsAndCrosses
  describe Game do
    it 'sets up a game with 0 going first' do
      o_player = instance_double(Player, get_move: Move.new(Point.middle, Nought))
      x_player = instance_double(Player, get_move: nil)

      game = Game.new(o_player, x_player)
      game.run

      expect(o_player).to have_received(:get_move)
      expect(x_player).not_to have_received(:get_move)
    end

    it 'sets up a game with X going first' do
      x_player = instance_double(Player, get_move: Move.new(Point.middle, Cross))
      o_player = instance_double(Player, get_move: nil)

      game = Game.new(x_player, o_player)
      game.run

      expect(x_player).to have_received(:get_move)
      expect(o_player).not_to have_received(:get_move)
    end

    describe 'Game Events' do
      let(:game_start_action)   { double(:game_start_action, call: nil) }
      let(:game_over_action)    { double(:game_over_action, call: nil) }
      let(:turn_change_action)  { double(:turn_change_action, call: nil) }
      let(:invalid_move_event)  { double(:invalid_move_event, call: nil) }
      let(:invalid_input_event) { double(:invalid_input_event, call: nil) }

      let(:events) do
        {
          game_start:   Proc.new  { game_start_action.call },
          game_over:    Proc.new  { game_over_action.call },
          turn_change:  Proc.new  { turn_change_action.call },
          invalid_move: Proc.new  { invalid_move_event.call },
          invalid_input: Proc.new { invalid_input_event.call }
        }
      end

      it 'triggers a game start event when the game starts' do
        x_player = instance_double(Player, get_move: Move.new(Point.middle, Cross))
        o_player = instance_double(Player, get_move: Move.new(Point.top_left, Nought))

        game = Game.new(x_player, o_player, events)
        2.times { game.run }

        expect(game_start_action).to have_received(:call).once
      end

      it 'triggers a game over event when the game is complete' do
        game_state = create_game(<<~EXAMPLE
          -----
          |  X|
          | 0X|
          |X0 |
          -----
        EXAMPLE
        )
        x_player = instance_double(Player, get_move: Move.new(Point.top_middle, Nought))

        game = Game.new(x_player, instance_double(Player, get_move: nil), events, game_state)
        game.run

        expect(game_over_action).to have_received(:call)
      end

      it 'triggers an event when there is a change in turn' do
        x_player = instance_double(Player, get_move: Move.new(Point.middle, Cross))
        o_player = instance_double(Player, get_move: nil)

        game = Game.new(x_player, o_player, events)
        game.run

        expect(turn_change_action).to have_received(:call)
      end

      it 'triggers an event when an invalid move is entered' do
        x_player = instance_double(Player, get_move: Move.new(Point.middle, Cross))
        o_player = instance_double(Player, get_move: Move.new(Point.middle, Nought))

        game = Game.new(x_player, o_player, events)
        2.times { game.run }

        expect(invalid_move_event).to have_received(:call)
      end

      it 'triggers an event when an invalid input is entered' do
        x_player = instance_double(Player, get_move: nil)
        o_player = instance_double(Player, get_move: nil)
        allow(x_player).to receive(:get_move).and_raise(InvalidInputError)

        Game.new(x_player, o_player, events).run

        expect(invalid_input_event).to have_received(:call)
      end
    end
  end
end

module NoughtsAndCrosses
  class SetupPlayers
    attr_reader :players

    GAME_TYPES = {
      'Human vs Human'       => [ CommandLinePlayer, CommandLinePlayer ],
      'Human vs Computer'    => [ CommandLinePlayer, ComputerPlayer ],
      'Computer vs Human'    => [ ComputerPlayer, CommandLinePlayer ],
      'Computer vs Computer' => [ ComputerPlayer, ComputerPlayer ]
    }

    MARKS = {
      '0' => Nought,
      'X' => Cross
    }

    def initialize
      @players = []
    end

    def ready?
      players.count == 2 && players.all? {|player| player.kind_of? Player }
    end

    def prompt
      if @players.empty?
        prompt_for_game_type
      else
        prompt_for_starting_mark
      end
    end

    def call(input)
      raise InvalidInputError.new("Selection must be a number") unless input.match(/\d/)
      if @players.empty?
        select_game_type(input.to_i - 1)
      else
        select_starting_mark(input.to_i - 1)
      end
    end

    private

    def prompt_for_game_type
      game_types_prompt = GAME_TYPES.keys.map.with_index do |type, index|
        "#{index.next.to_s}. #{type}\n"
      end.join
      "Select a game type, left-hand player starts:\n#{game_types_prompt}"
    end

    def prompt_for_starting_mark
      marks_prompt = MARKS.keys.map.with_index do |mark, index|
        "#{index.next.to_s}. #{mark}\n"
      end.join
      "Select the mark of the starting player:\n#{marks_prompt}"
    end

    def select_game_type(selection_number)
      selection = GAME_TYPES.values[selection_number]
      if selection.nil?
        raise InvalidInputError.new(
          "Selection must be a number between 1 and #{GAME_TYPES.to_a.count}"
        )
      else
        @players = selection
      end
      self
    end

    def select_starting_mark(selection)
      selection = MARKS.values[selection]
      if selection.nil?
        raise InvalidInputError.new("Selection must be a number between 1 and #{GAME_TYPES.to_a.count}")
      else
        @players = @players.zip([selection, selection.opponent]).map do |player, mark|
          player.new(mark)
        end
        self
      end
    end
  end
end

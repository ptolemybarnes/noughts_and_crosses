module NoughtsAndCrosses
  describe SetupPlayers do

    subject(:setup) { described_class.new }

    it { is_expected.to_not be_ready }

    it 'prompts for the selection of a game type' do
      expect(setup.prompt).to eq(<<~PROMPT
        Select a game type, left-hand player starts:
        1. Human vs Human
        2. Human vs Computer
        3. Computer vs Human
        4. Computer vs Computer
      PROMPT
      )
    end

    it 'takes a game type and then prompts for the starting player' do
      setup.call("1")

      expect(setup.prompt).to eq(<<~PROMPT
        Select the mark of the starting player:
        1. 0
        2. X
      PROMPT
      )
    end

    it 'is ready when a game type and starting mark have been specified' do
      setup.call("1")
      setup.call("1")

      expect(setup).to be_ready
    end
  end
end

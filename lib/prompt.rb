class Prompt
  def initialize &block
    @prompt = block
  end

  def gets
    @prompt.call
    STDIN.gets.chomp
  end
end

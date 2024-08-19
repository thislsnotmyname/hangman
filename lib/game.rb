# JM, 08/18/2024
#
# This class handles the flow of the game.
class Game
  def initialize
    @secret_word = File.readlines('10000_words.txt').filter { |word| word.chomp.length.between?(5, 12) }.sample.chomp
    @incorrect_guesses = []
    @correct_parts = ('_' * @secret_word.length).split('')

    puts 'Guess the secret word: '
    game_loop
  end

  def game_loop
    display
    while @incorrect_guesses.length < 7
      check(player_input)
      display
      return win('Human') unless @correct_parts.any? '_'
    end
    win('Computer')
  end

  def display
    puts '  ' << @correct_parts.join(' ')
    puts "Incorrect letters: #{@incorrect_guesses.join(' ')} | Chances: #{7 - @incorrect_guesses.length}"
  end

  def player_input
    loop do
      input = gets.chomp

      if input.start_with? '!'
        # return inputted_command(input)
      elsif input.length == 1 && input.match?(/[a-zA-Z]/) && !@incorrect_guesses.include?(input)
        return input
      else
        print "\e[1A\e[2K"
      end
    end
  end

  def check(player_input)
    return @incorrect_guesses << player_input unless @secret_word.match?(player_input.downcase)

    @secret_word.split('').each_with_index do |char, idx|
      @correct_parts[idx] = player_input if char == player_input
    end
    @correct_parts
  end

  private

  attr_reader :secret_word

  def win(winner)
    puts winner
    winner
  end
end

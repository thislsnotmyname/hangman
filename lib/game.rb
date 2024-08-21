require_relative 'game/serializable'
require_relative 'game/commandable'
require_relative 'inputtable'
# JM, 08/21/2024
#
# This class handles the flow of the game.
class Game
  include Commandable
  include Serializable
  include Inputtable

  attr_reader :correct_parts, :incorrect_guesses

  def initialize(loaded = {})
    @file = loaded[:file] || :new_game
    @secret_word = loaded[:@secret_word] ||
                   File.readlines('10000_words.txt').filter { |word| word.chomp.length.between?(5, 12) }.sample.chomp

    @incorrect_guesses = loaded[:@incorrect_guesses] || []
    @correct_parts = loaded[:@correct_parts] || ('_' * @secret_word.length).split('')

    game_loop
  end

  def game_loop
    puts 'Guess the secret word: '
    display
    while @incorrect_guesses.length < 7
      input = player_input

      return end_game(input) if input.instance_of?(Symbol)

      check input unless input.nil?
      display
      return win('Human') unless @correct_parts.any? '_'
    end
    win('Computer')
  end

  def display
    puts '  ' << @correct_parts.join(' ')
    puts "Incorrect letters: #{@incorrect_guesses.join(' ')} | Chances left: #{7 - @incorrect_guesses.length}"
  end

  def player_input
    print 'Guess a letter (Type .help to list commands): '
    while (input = gets.chomp)
      break if input.match?(/[a-zA-Z.]/) && !@incorrect_guesses.include?(input) && !@correct_parts.include?(input)

      delete_input
      print 'Guess a letter (Type .help to list commands): '
    end
    return inputted_command(input) if input.start_with? '.'

    input[0]
  end

  private

  attr_reader :secret_word, :file
  attr_writer :correct_parts, :incorrect_guesses

  def check(player_input)
    return @incorrect_guesses << player_input unless @secret_word.match?(player_input.downcase)

    @secret_word.split('').each_with_index do |char, idx|
      @correct_parts[idx] = player_input if char == player_input
    end
    @correct_parts
  end

  def end_game(reason)
    File.delete(@file) if @file != :new_game && %i[menu_complete exit_complete].include?(reason)
    Menu.main_menu if %i[menu_complete menu_saved].include?(reason)
    Menu.show_save_files if reason == :load
    nil if %i[exit_complete exit_saved].include?(reason)
  end

  def win(winner)
    print winner == 'Human' ? 'You win! ' : 'Computer wins! '
    puts "The secret word was: #{@secret_word}"
    puts 'Return to main menu? [y/n]: '
    end_game(get_valid_input(/[yn]/).match?(/y/) ? :menu_complete : :exit_complete)
  end
end

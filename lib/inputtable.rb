# JM, 08/21/2024
#
# This module gives a basic input loop to get a valid input from the user based on a regex.
module Inputtable
  def get_valid_input(regex)
    while (input = gets.chomp)
      next delete_input if input == ''
      break if input.match?(regex)

      delete_input
    end
    input[0]
  end

  def delete_input
    print "\e[1A\e[2K"
  end
end

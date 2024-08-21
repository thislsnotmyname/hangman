# JM, 08/21/2024
#
# This module handles commands during the game.
module Commandable
  def inputted_command(input)
    return save_game if input.downcase.match?(/\.save|\.s/)
    return load_game if input.downcase.match?(/\.load!|\.l!/)
    return load_game(:ask) if input.downcase.match?(/\.load|\.l/)

    return unless input[0..1] == '.' || input.downcase.match?(/\.help|\.h/)

    puts "\n Valid commands:\n"\
    " |  ., .h, .help - Displays command list\n"\
    " |  .s, .save - Saves current game\n"\
    " |  .l, .load - Load previous game (asks to save first)\n"\
    " |  .l!, .load! - Load previous game (does NOT ask to save first)\n"\
    "\n"
  end

  def save_game(load = :no)
    next_default_name = Dir.children('saves/').select { |save| save.match?(/save[0-9]{2}/) }.length
    next_default_name = next_default_name < 10 ? "save0#{next_default_name}" : "save#{next_default_name}"
    puts "Input a name for your saved game (leave blank to save with name: #{next_default_name}): "
    file_name = gets.chomp
    save_to("saves/#{file_name.empty? ? next_default_name : file_name}.yaml")
    return if load == :from_load

    puts 'Return to main menu? [y/n]: '
    get_valid_input(/[yn]/).match?(/y/) ? :menu_saved : :exit_saved
  end

  def load_game(ask_to_save = :dont_ask)
    return :load if ask_to_save == :dont_ask

    puts 'Save current game first? [y/n]:'
    save_game(:from_load) if get_valid_input(/[yn]/).match?(/y/)
    :load
  end
end

require 'time'
require_relative 'inputtable'
require_relative 'game'
# JM, 08/21/2024
#
# This class handles the main menu in addition to the saved file loading.
class Menu
  extend Inputtable

  def self.show_save_files(page = 0)
    files = []
    print "\nChoose a saved file to open (! to go back"
    puts Dir.children('saves/').length > 10 ? ', + to go forward, - to go backward):' : '):'

    Dir.children('saves/').sort.each_with_index do |save_file, idx|
      next unless (page..(page + 9)).include?(idx)

      files << save_file.chomp
      puts "[#{idx}] #{save_file.gsub('.yaml', '').chomp}"\
      " | Saved: #{saved_time(save_file)}"
    end

    navigate_saves(page, files, files.length)
  end

  def self.navigate_saves(page, files, amount_of_saves)
    choice = get_valid_input(/[0-#{amount_of_saves - 1}\-!+]/)

    return Game.load_state("saves/#{files[choice.to_i]}") if choice.match?(/[[:digit:]]/)
    return show_save_files(page + 1) if choice == '+'
    return show_save_files(page.positive? ? page - 1 : 0) if choice == '-'

    main_menu if choice == '!'
  end

  def self.main_menu
    puts "\nHangman\n"\
    "Please select mode:\n"\
    '[1] (N)ew Game'
    puts '[2] (C)ontinue' unless Dir.empty?('saves/')
    puts '[3] (Q)uit'
    choice = get_valid_input(/[1-3ncqNCQ!]/)

    Game.new if choice.match?(/[1nN]/)
    show_save_files if choice.match?(/[2cC]/)
    nil if choice.match?(/[3qQ!]/)
  end

  # private_class_method :saved_time

  def self.saved_time(save_file)
    File.mtime("saves/#{save_file}").strftime('%D %H:%M:%S')
  end
end

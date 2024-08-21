require_relative 'lib/menu'

# JM, 08/21/2024

Dir.mkdir('saves') unless Dir.exist?('saves')
Menu.main_menu

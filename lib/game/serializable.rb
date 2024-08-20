require 'time'
require 'yaml'
# JM, 08/19/2024
#
# This module serializes objects to create a save state.
module Serializable
  def save(file)
    puts "Saving state to (#{file}) . . ."
    save_hash = { time_saved: Time.now }
    instance_variables.each do |var|
      save_hash[var] = instance_variable_get(var)
    end
    File.open(file, 'w') do |f|
      f.write(YAML.dump(save_hash))
    end
    puts 'Saved!'
  end

  def load(file)
    file = File.read(file)
    puts "Loading state from (#{file}) . . ."
    loaded = YAML.safe_load(file, permitted_classes: [Time, Symbol])
    puts 'Loaded!'
    new(loaded)
  end
end

require 'time'
require 'yaml'
# JM, 08/21/2024
#
# This module serializes objects to create a save state.
module Serializable
  def self.included(base)
    base.extend Loadable
  end

  def save_to(file)
    puts "Saving state to (#{file}) . . ."
    save_hash = { time_saved: Time.now, file: file }
    instance_variables.each do |var|
      save_hash[var] = instance_variable_get(var)
    end
    File.open(file, 'w') do |f|
      f.write(YAML.dump(save_hash))
    end
    puts 'Saved!'
  end

  # This module contains a class method, so it must be separated from the instance method: save
  module Loadable
    def load_state(file)
      puts "Loading state from (#{file}) . . ."
      file = File.read(file)
      loaded = YAML.safe_load(file, permitted_classes: [Time, Symbol])
      puts 'Loaded!'
      new(loaded)
    end
  end
end

##
# Verboten
#
# Copyright 2016 Richard Davis GPL v3

require 'json'
require './mycontroller'

##
# Prompts user for configuration and saves as hash
#
def interactive
  puts 'Server =>'
  server = STDIN.gets.chomp

  puts 'Port => '
  port = STDIN.gets.chomp

  puts 'Nick => '
  nick = STDIN.gets.chomp

  puts 'Ident => '
  ident = STDIN.gets.chomp

  puts 'Gecos => '
  gecos = STDIN.gets.chomp

  puts 'Channel => '
  chan = STDIN.gets.chomp

  config = {
    'server' => server,
    'port' => port,
    'nick' => nick,
    'ident' => ident,
    'gecos' => gecos,
    'chan' => chan
  }
end

##
# Writes given configuration to JSON file
#
def to_file config
  # TODO add error handling
  File.open(ENV['HOME']+'/.vbot/config.json', 'w') do |f|
    f.write(JSON.pretty_generate(config))
  end
end

##
# Parses configuration as hash from JSON file
#
def from_file
  # TODO add error handling
  f = File.read(ENV['HOME']+'/.vbot/config.json')
  config = JSON.parse f
end

##
# Launches interactive mode to prompt user for configuration
# if argument 'i' is given, or retrieves configuration from
# the config.json file
#
if ARGV[0] == 'i'
  config = interactive
  puts 'Save configuration? (Y/N)'
  choice = STDIN.gets.chomp.upcase
  to_file config if choice == 'Y'
else
  config = from_file
end

# TODO add error handling
vbot = MyController.new config

trap("INT") { vbot.close_connection }

# TODO add error handling
vbot.handle_connection


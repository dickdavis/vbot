# vbot: an IRC bot library in Ruby
## Description
`vbot` is an IRC bot library that aims to be make building and extending IRC bots more efficient.

## Quick Guide
To build a `vbot` bot, you may either:

* Install the `vbot` gem by executing command:
```
gem install vbot
```

* Or require it in your project Gemfile:
```
gem 'vbot', '~> 0.2.1
```

Then,
* Implement your methods in a module.
* Subclass `Vbot::BotController` and include the module.
* Write a script to run the bot.

### Write a Module
Write a module to perform custom functionality.
```
##
# Module to add functionality to MyMsgLogic
#
module QuoteHayek
  def get_quote
    'Emergencies have always been the pretext on which the'\
    ' safeguards of individual liberty have been eroded.'
  end
end
```

### Subclass Vbot::BotController Class
Subclass the `Vbot::BotController` class and include the modules containing the custom functionality.
Override the `exec_command_subroutine` method to use the new functionality, returning a string to send
to the IRC server if you desire a response message to be sent.

The message from the server containing the command is parsed into a hash that should get passed into the
`exec_command_subroutine` method. The hash contains
* the reply to nick (`command_hash[:reply_to] // string`),
* whether the command was given via channel or private message (`command_hash[:pm] // boolean: true if given via PM`), 
* the actual command (`command_hash[:command] // string`),
* and any arguments that follow the command (`command_hash[:arguments] // array`).
```
require 'vbot'
require './quotehayek.rb'

##
# Adds custom command subroutine to bot.
class MyBot < Vbot::BotController
  include QuoteHayek

  ##
  # Executes command subroutines.
  def exec_command_subroutine(command_hash)
    if command_hash[:command].upcase == 'HOWDY' && command_hash[:pm] == true
      "PRIVMSG #{command_hash[:reply_to]} :Howdy, #{command_hash[:reply_to]}.\r\n"
    elsif command_hash[:command].upcase == 'HOWDY' && command_hash[:pm] == false
      "PRIVMSG #{@chan} :Howdy, #{command_hash[:reply_to]}.\r\n"
    end
  end
end
```

### Write a Script to Run the Bot
Require the subclass of `VbotController`
```
require './my_bot'
```
Initialize a configuration hash with the connection details
```
config = {
  'server' => 'hackerchan.org',   # the server for tcp socket
  'port' => 6667,                 # the port for tcp socket
  'nick' => 'mybot',              # the desired nickname
  'ident' => 'vbot',              # the user name
  'gecos' => 'MyBot 0.0.1',       # the real name
  'chan' => '#dailyprog',         # the channel to join
}
```
Instantiate a controller object, passing the configuration hash as an argument
```
vbot = MyBot.new config
```
Trap interrupt signal (CTRL-c) to close the connection to the IRC server
```
trap("INT") { vbot.close_connection }
```
Handle the connection
```
vbot.handle_connection
```

### Give Commands
To give commands to your bot, send it a message over IRC structured as:
```
"(BOT'S NICK) (COMMAND) (ARGUMENTS)"
```

Example:
```
$ verboten quote-hayek
```

## TODO
* Increase test coverage.

## Changelog
### 2018-11-03
* Refactored project files.
* Structured test file.
* Added documentation and rdoc rake task.
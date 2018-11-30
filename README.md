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
gem 'vbot', '~> 0.4.0
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
Override the `parse_message` method to respond to a message sent to it. Then, create a method to perform a desired action.
This newly created method should return a string formatted similar to the return values in the example method below.

```
require 'vbot'
require './quotehayek.rb'

##
# Adds custom command subroutine to bot.
class MyBot < Vbot::BotController
  include QuoteHayek

  ##
  # Performs logic on message to determine response.
  def parse_message(data)
    return exec_command_subroutine(interpret_command(data)) if data[1] == 'PRIVMSG' && (data[3] == ":#{@nick}" || data[3] == ':<>')
    super
  end

  ##
  # Executes command subroutines.
  def exec_command_subroutine(command_hash)
    rt = command_hash[:reply_to]
    pm = command_hash[:pm]
    cmd = command_hash[:command]
    args = command_hash[:arguments]

    if cmd.upcase == 'HOWDY'
      if pm == true
        ["PRIVMSG #{rt} :Howdy, #{rt}.\r\n"]
      else
        ["PRIVMSG #{@chan} :Howdy, #{rt}.\r\n"]
      end
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

Of course, you are not required to use the bot's nick as the trigger.

## TODO
* Increase test coverage.

## Changelog
### 2018-11-29
* Refactored `parse_message` method to remove reference to `exec_command_subroutine` method. This will allow subclasses to define their own logic for handling triggers.

### 2018-11-03
* Refactored project files.
* Structured test file.
* Added documentation and rdoc rake task.

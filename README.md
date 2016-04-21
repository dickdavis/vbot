#verboten: an IRC bot library in Ruby
##Description
`verboten` is an IRC bot library that aims to be make running easy to extend and implement. If you like the way this project is going, feel free to contribute.

The `VbotController` class establishes, maintains, and closes the connection to the IRC server, while the `VbotMsgLogic` class contains the controlling logic for responding to messages from the IRC server. `verboten-manager` gets the configuration from a JSON file or interactively from the user.

##Quick Guide
To add functionality to `verboten`:
* implement your methods in a module
* include the module in a subclass the `VbotMsgLogic` class
* override the `VbotMsgLogic::hear_command` method
* instantiate `VbotMsgClass` as instance variable of `VbotController` subclass
* write manager script to run bot

###Write a Module

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


###Subclass VbotMsgLogic class

```
require './vbotmsglogic.rb'
require './quotehayek.rb'

##
# Extends VbotMsgLogic, implementing new functionality in bot
#
class MyMsgLogic < VbotMsgLogic
  include QuoteHayek

  ##
  # Define hear_command method to respond to commands in module
  #
  def hear_command data
    # get the nick to reply to
    rt = get_nick_rt data[0]
    # get the command
    command = data[4]
    # runs method from module if command is given
    if command.upcase == 'QUOTE'
      response = get_quote
      "PRIVMSG #{rt} #{response} - F.A. Hayek"
    end
  end
end
```

###Subclass VbotController class

```
require './vbotcontroller'
require './mymsglogic.rb'

##
# Extends the Vbot Controller class adding new message logic
#
class MyController < VbotController

  ##
  # Initializes MyController object with MyMsgLogic
  #
  def initialize config
    super
    # instantiate subclass of VbotMsgLogic
    @msg_logic = MyMsgLogic.new config end
end
```

###Write a manager script to run your new bot
Require the subclass of `VbotController`
```
require './mycontroller'
```
Initialize a configuration hash with the connection details
```
config = {
  'server' => 'irc.freenode.net',   # the server for tcp socket
  'port' => 6667,                   # the port for tcp socket
  'nick' => 'verboten',             # the desired nickname
  'ident' => 'vbot',                # the user name
  'gecos' => 'Verboten 0.0.1',      # the real name
  'chan' => '#ruby',                # the channel to join
 }
```
Instantiate a controller object, passing the configuration hash as an argument
```
vbot = MyController.new config
```
Trap interrupt signal (CTRL-c) to close the connection to the IRC server
```
trap("INT") { vbot.close_connection }
```
Handle the connection
```
vbot.handle_connection
```

###Give Commands
The only command that Verboten knows natively is the `hello` command.
`verboten` will respond to channel or private messages, but he will respond in a private message by default.
To give commands to your bot, send it a message over IRC structured as
"(BOT'S NICK) (COMMAND) (ARGUMENTS)"
Example:
```
$ /msg verboten verboten quote
```

##TODO
* `VbotManager` class that manages a queue of `VbotController` instances in threads.
* Modular bot functionalities.

##License
LGPL v2.1

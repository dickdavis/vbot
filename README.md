#verboten: an IRC bot library in Ruby
##Description
`verboten` is an IRC bot library that aims to be make running easy to extend and implement. If you like the way this project is going, feel free to contribute.

The `VbotController` class establishes, maintains, and closes the connection to the IRC server, while the `VbotMsgLogic` class contains the controlling logic for responding to messages from the IRC server. `verboten-manager` gets the configuration from a JSON file or interactively from the user.

##Quick Guide for VbotController Class
Require the `VbotController` class
```
require './vbotcontroller'
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
Instantiate a new `VbotController` object, passing the configuration hash as an argument
```
vbot = VbotController.new config
```
Trap interrupt signal (CTRL-c) to close the connection to the IRC server
```
trap("INT") { vbot.close_connection }
```
Handle the connection
```
vbot.handle_connection
```

##Adding Functionality
To add functionality to `verboten`, you must implement your methods in a module, include them in the `VbotMsgLogic` class, and then modify the `hear_command` method so that `verboten` will recognize and respond to the new commands.

Implement the desired functionality in a module
```
module QuoteHayek
  def get_quote
    "Emergencies' have always been the pretext on which the safeguards of individual liberty have been eroded."
  end
end
```

Create your own message logic class, extending `VbotMsgLogic`
```
class MyMsgLogic
  extend VbotMsgLogic
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
    return get_quote if command.upcase == 'QUOTE"
  end
end
```

##TODO
* `VbotManager` class that manages a queue of `VbotController` instances in threads.
* Modular bot functionalities.

##License
GPL v3

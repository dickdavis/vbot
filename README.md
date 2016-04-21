#verboten: an IRC bot in Ruby
##Description
`verboten` is an IRC bot that aims to be easy to extend and implement. If you like the way this project is going, feel free to contribute.

The `VerbotenController` class establishes, maintains, and closes the connection to the IRC server, while the `VbotMsgLogic` class contains the controlling logic for responding to messages from the IRC server.

##Quick Guide
Require the `VerbotenController` class
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
Instantiate a new `VerbotenController` object, passing the configuration hash as its an argument
```
vbot = VerbotenController.new config
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


##TODO
* `VbotManager` class that manages a queue of `VbotController` instances in threads.
* Modular bot functionalities.

##License
GPL v3

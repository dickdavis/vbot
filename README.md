#verboten
##Description
`Verboten` is an IRC bot that aims to be easy to extend and implement. If you like the way this project is going, feel free to contribute.

##Quick Guide
Require the `Verboten` class
```
require './verboten'
```
Initialize a configuration hash
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
Instantiate a new Verboten object, passing configuration hash as argument
```
verb = Verboten.new config
```
Trap interrupt signal (CTRL-c) to close the connection to the IRC server
```
trap("INT") { verb.close_connection }
```
Handle the connection
```
verb.handle_connection
```
Look at methods to explore capabilities. More to come.


##TODO
* `VerbotenController` class that manages a queue of `Verboten` instances in threads.
* Modular bot functionalities.

##License
GPL v3

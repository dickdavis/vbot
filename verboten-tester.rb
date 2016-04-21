require './verboten'
config = {
  'server' => 'irc.maddshark.net',
  'port' => 6668,
  'nick' => 'verboten',
  'ident' => 'vbot',
  'gecos' => 'Verboten 0.0.1',
  'chan' => '#fnord',
}

verb = Verboten.new config

trap("INT") { verb.close_connection }

verb.handle_connection

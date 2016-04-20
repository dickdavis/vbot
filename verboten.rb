require 'socket'

# connection configuration
server = 'irc.maddshark.net'
port = 6668
nickname = 'verboten'
ident = 'vbot'
gecos = 'Verboten 0.0.1'
channel = '#discord'

# open a socket
socket = TCPSocket.open(server, port)

socket.puts "NICK #{nickname}\r\n"
socket.puts "USER #{ident} * 8 :#{gecos}\r\n"

until socket.closed?
  buffer = socket.gets
  data = buffer.split
  socket.puts "PONG #{data[1]}" if data[0] == 'PING'
  socket.puts "JOIN #{channel}\r\n" if data[1] == '376' || data[1] == '422'
  puts buffer
end


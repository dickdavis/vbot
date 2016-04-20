require 'socket'

# connection configuration
server = 'irc.maddshark.net'
port = 6668
nickname = 'verboten'
ident = 'vbot'
gecos = 'Verboten 0.0.1'
channel = '#fnord'

# open a socket
socket = TCPSocket.open(server, port)

trap "INT" { socket.puts 'QUIT' ; socket.close }

socket.puts "NICK #{nickname}\r\n"
socket.puts "USER #{ident} * 8 :#{gecos}\r\n"

until socket.closed? do
  buffer = socket.gets
  data = buffer.split
  socket.puts "PONG #{data[1]}" if data[0] == 'PING'
  socket.puts "JOIN #{channel}\r\n" if data[1] == '376' || data[1] == '422'
  if data[1] == "PRIVMSG" && data[3] == ":verboten"
    rt = data[0]
    last = 1
    rt.each_char.with_index do |char, i|
      last = i-1 if char == '!'
    end
    capture_rt = rt.slice(1, last)
    socket.puts "PRIVMSG #{capture_rt} Hello, world.\r\n"
  end
  puts buffer
end


require 'socket'

class Verboten
  attr_reader :server, :port, :nick, :ident, :gecos, :chan

  def initialize config
    @server = config['server']
    @port = config['port']
    @nick = config['nick']
    @ident = config['ident']
    @gecos = config['gecos']
    @chan = config['chan']
    start_connection
  end

  def send_msg msg
    @socket.puts msg
  end

  def join_channel
    send_msg "JOIN #{@chan}\r\n"
  end

  def handle_ping token
    send_msg "PONG #{token}"
  end

  def get_user_rt msg
    last = 1
    msg.each_char.with_index do |char, i|
      last = i-1 if char == '!'
    end
    rt = msg.slice(1, last)
  end

  def start_connection
    @socket = TCPSocket.open @server, @port
    send_msg "NICK #{@nick}\r\n"
    send_msg "USER #{@ident} * 8 :#{@gecos}\r\n"
  end

  def handle_connection
    begin
      until @socket.eof? do
        buffer = @socket.gets
        puts buffer
        data = buffer.split
        handle_ping data[1] if data[0] == 'PING'
        join_channel if data[1] == '376' || data[1] == '422'
        if data[1] == "PRIVMSG" && data[3] == ":verboten"
          msg = data[0]
          rt = get_user_rt msg
          send_msg "PRIVMSG #{rt} Hello, world.\r\n"
        end
      end
    rescue
      puts "\nTerminating connection."
    end
  end

  def close_connection
    send_msg 'QUIT'
    @socket.close
  end
end


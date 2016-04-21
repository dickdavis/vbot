##
# Verboten
#
# Copyright 2016 Richard Davis GPL v3
require 'socket'

##
# This class serves as an IRC bot
#
class Verboten
  attr_reader :server, :port, :nick, :ident, :gecos, :chan

  ##
  # Initializes a Verboten object with configuration details
  # stored in argument as a hash
  #
  def initialize config
    @server = config['server']
    @port = config['port']
    @nick = config['nick']
    @ident = config['ident']
    @gecos = config['gecos']
    @chan = config['chan']
    start_connection
  end

  ##
  # Handles writing to socket output
  #
  def send_msg msg
    @socket.puts msg
  end

  ##
  # Joins to channel on IRC server
  #
  def join_channel
    send_msg "JOIN #{@chan}\r\n"
  end

  ##
  # Handles ping message from server
  #
  def handle_ping token
    send_msg "PONG #{token}"
  end

  ##
  # Gets the nick to reply to
  #
  def get_nick_rt msg
    last = 1
    msg.each_char.with_index do |char, i|
      last = i-1 if char == '!'
    end
    rt = msg.slice(1, last)
  end

  ##
  # Starts the connection to the server and provides identification
  #
  def start_connection
    @socket = TCPSocket.open @server, @port
    send_msg "NICK #{@nick}\r\n"
    send_msg "USER #{@ident} * 8 :#{@gecos}\r\n"
  end

  ##
  # Handles the connection to the server
  #
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
          rt = get_nick_rt msg
          send_msg "PRIVMSG #{rt} Hello, world.\r\n"
        end
      end
    rescue
      puts "\nTerminating connection."
    end
  end

  ##
  # Closes the connection to the server
  #
  def close_connection
    send_msg 'QUIT'
    @socket.close
  end
end


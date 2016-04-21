##
# Verboten
#
# Copyright 2016 Richard Davis GPL v3
require 'socket'
require './vbotmsglogic'

##
# This class establishes, maintains, and closes the connection
# to the IRC server
#
class VbotController
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
    @msg_logic = VbotMsgLogic.new config
    start_connection
  end

  ##
  # Handles writing to socket output
  #
  def send_msg msg
    @socket.puts msg
  end
  ##
  # Starts the connection to the server and provides identification
  #
  def start_connection
    @socket = TCPSocket.open @server, @port
    send_msg "#{@msg_logic.nick_to_server}"
    send_msg "#{@msg_logic.ident_with_server}"
  end

  ##
  # Handles the connection to the server
  #
  def handle_connection
    begin
      until @socket.eof? do
        buffer = @socket.gets
        puts buffer
        puts '--------------EOM (server)-------------'
        msg = buffer.split
        response = @msg_logic.discern msg
        unless response.nil?
          send_msg response
          puts "#{@nick.upcase} => #{response}"
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


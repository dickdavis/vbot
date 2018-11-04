# frozen_string_literal: true

# Copyright 2018 Richard Davis
#
# This file is part of vbot.
#
# vbot is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# vbot is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with vbot.  If not, see <http://www.gnu.org/licenses/>.

require 'socket'

module Vbot
  ##
  # = BotController
  # Author::    Richard Davis
  # Copyright:: Copyright 2018 Richard Davis
  # License::   GNU Public License 3
  #
  # This class establishes, maintains, and closes the connection
  # to the IRC server.
  class BotController
    # The IRC server to connect to.
    attr_reader :server
    # The port to connect over.
    attr_reader :port
    # The nick for the bot.
    attr_reader :nick
    # The name to identify to the server with.
    attr_reader :ident
    # The gecos for the bot.
    attr_reader :gecos
    # The channel on the IRC server to join.
    attr_reader :chan

    ##
    # Initializes a VbotController object
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
    # Starts the connection to the server and provides identification.
    def start_connection
      @socket = TCPSocket.open @server, @port
      send_message nick_to_server
      send_message ident_with_server
    end

    ##
    # Handles the connection to the server.
    def handle_connection
      begin
        until @socket.eof? do
          buffer = @socket.gets
          puts buffer
          msg = buffer.split
          response = parse_message msg
          unless response.nil?
            send_message response
            puts "#{@nick.upcase} => #{response}"
          end
        end
      rescue SocketError => e
        puts e
        close_connection
        puts "\nERROR IN CONNECTION. Terminating...\n"
      end
    end

    ##
    # Closes the connection to the server.
    def close_connection
      send_message quit_from_server
      @socket.close
    end

    private

    ##
    # Gives nick to server.
    def nick_to_server
      "NICK #{@nick}\r\n"
    end

    ##
    # Identifies with server.
    def ident_with_server
      "USER #{@ident} * 8 :#{@gecos}\r\n"
    end

    ##
    # Joins to channel on IRC server.
    def join_to_channel
      "JOIN #{@chan}\r\n"
    end

    ##
    # Quits IRC server.
    def quit_from_server
      'QUIT'
    end

    ##
    # Handles ping message from server.
    def handle_ping token
      "PONG #{token}"
    end

    ##
    # Gets the nick to reply to.
    def get_nick_rt(raw_rt)
      last = 1
      raw_rt.each_char.with_index do |char, i|
        last = i-1 if char == '!'
      end
      raw_rt.slice(1, last)
    end

    ##
    # Determines if private message.
    def is_private_message?(window)
      return false if window == @chan
      true
    end

    ##
    # Parses the message from the server into a hash.
    def interpret_command(data)
      {
        reply_to: get_nick_rt(data[0]),
        pm: is_private_message?(data[2]),
        command: data[4],
        arguments: data.slice(5..-1)
      }
    end

    ##
    # Executes command subroutines.
    def exec_command_subroutine(command_hash)
      if command_hash[:command].upcase == 'HOWDY' && command_hash[:pm] == true
        "PRIVMSG #{command_hash[:reply_to]} :Howdy, #{command_hash[:reply_to]}.\r\n"
      elsif command_hash[:command].upcase == 'HOWDY' && command_hash[:pm] == false
        "PRIVMSG #{@chan} :Howdy, #{command_hash[:reply_to]}.\r\n"
      end
    end

    ##
    # Performs logic on message to determine response.
    def parse_message(data)
      return handle_ping data[1] if data[0] == 'PING'
      return join_to_channel if data[1] == '376' || data[1] == '422'
      return exec_command_subroutine(interpret_command(data)) if data[1] == 'PRIVMSG' && data[3] == ":#{@nick}"
    end

    ##
    # Writes to socket output.
    def send_message(msg)
      @socket.puts msg
    end
  end
end

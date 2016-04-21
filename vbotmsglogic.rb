##
# VbotMsgLogic
#
# Copyright 2016 Richard Davis GPL v3

##
# This class serves as the controlling logic for responding
# to messages from the IRC server
#
class VbotMsgLogic

  def initialize config
    @nick = config['nick']
    @ident = config['ident']
    @gecos = config['gecos']
    @chan = config['chan']
  end

  ##
  # Gives nick to server
  #
  def nick_to_server
    "NICK #{@nick}\r\n"
  end

  ##
  # Identifies with server
  #
  def ident_with_server
    "USER #{@ident} * 8 :#{@gecos}\r\n"
  end

  ##
  # Joins to channel on IRC server
  #
  def join_channel
    "JOIN #{@chan}\r\n"
  end

  ##
  # Handles ping message from server
  #
  def handle_ping token
    "PONG #{token}"
  end

  ##
  # Handles private message commands
  #
  def hear_command data
      rt = get_nick_rt data[0]
      command = data[4]
      if command.upcase == "HELLO"
        "PRIVMSG #{rt} Hello, #{rt}.\r\n"
      end
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
  # Performs logic on message to determine response
  #
  def discern data
    return handle_ping data[1] if data[0] == 'PING'
    return join_channel if data[1] == '376' || data[1] == '422'
    return hear_command data if data[1] == 'PRIVMSG' && data[3] == ":#{@nick}"
  end
end


# frozen_string_literal: true
module Meshchat
  module Network
    module Message
      extend ActiveSupport::Autoload

      # @see https://github.com/neuravion/mesh-chat/blob/master/message-types.md
      # chat types
      CHAT           = 'chat'
      EMOTE          = 'emote'
      WHISPER        = 'whisper'

      # fake type, actually renders as an emote
      ROLL           = 'roll'

      # status types
      PING           = 'ping'
      PING_REPLY     = 'pingreply'
      DISCONNECT     = 'disconnect'

      # node list sync types
      NODE_LIST      = 'nodelist'
      NODE_LIST_HASH = 'nodelisthash'
      NODE_LIST_DIFF = 'nodelistdiff'

      eager_autoload do
        autoload :Base
        autoload :Chat
        autoload :Emote
        autoload :Ping
        autoload :PingReply
        autoload :Disconnect
        autoload :Whisper
        autoload :NodeList
        autoload :NodeListDiff
        autoload :NodeListHash
        autoload :Factory
      end
    end
  end
end

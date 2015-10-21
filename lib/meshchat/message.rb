require 'meshchat/message/base'
require 'meshchat/message/chat'
require 'meshchat/message/ping'
require 'meshchat/message/ping_reply'
require 'meshchat/message/disconnection'
require 'meshchat/message/whisper'
require 'meshchat/message/relay'
require 'meshchat/message/node_list'
require 'meshchat/message/node_list_diff'
require 'meshchat/message/node_list_hash'

module MeshChat
  module Message
    CHAT = 'chat'
    PING = 'ping'
    PING_REPLY = 'pingreply'
    WHISPER = 'whisper'
    RELAY = 'relay'
    DISCONNECTION = 'disconnection'

    NODE_LIST = 'nodelist'
    NODE_LIST_HASH = 'nodelisthash'
    NODE_LIST_DIFF = 'nodelistdiff'

    TYPES = {
      CHAT => Chat,
      WHISPER => Whisper,
      DISCONNECTION => Disconnection,
      PING => Ping,
      PING_REPLY => PingReply,
      NODE_LIST => NodeList,
      NODE_LIST_DIFF => NodeListDiff,
      NODE_LIST_HASH => NodeListHash
    }


  end
end

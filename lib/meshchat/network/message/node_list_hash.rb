# frozen_string_literal: true
module Meshchat
  module Network
    module Message
      class NodeListHash < Base
        def message
          @_message ||= Node.as_sha512
        end

        # node list hash is received
        # @return [NilClass] no output for this message type
        def handle
          respond
          nil
        end

        def respond
          if message != Node.as_sha512
            Display.debug 'node list hashes do not match'

            node_list = _message_factory.create(
              NODE_LIST,
              data: { message: Node.as_json })

            _message_dispatcher.send_message(
              uid: payload['sender']['uid'],
              message: node_list
            )
          else
            Display.debug 'node list hash matches'
          end
        end
      end
    end
  end
end

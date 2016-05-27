# frozen_string_literal: true
module Meshchat
  module Network
    module Incoming
      # all this does is pull the encrypted message out of
      # the received request
      class RequestProcessor
        attr_reader :_message_processor

        def initialize(network: NETWORK_LOCAL, message_dispatcher: nil, location: nil)
          @_message_processor = MessageProcessor.new(
            network: network,
            message_dispatcher: message_dispatcher,
            location: location
          )
        end

        # @param [String] request_body - the encrypted message as a json string
        def process(request_body)
          encoded_message, uid = parse_content(request_body)
          _message_processor.process(encoded_message, uid)
        end

        def parse_content(content)
          content = JSON.parse(content) if content.is_a?(String)
          verify(content)

          [content['message'], content['uid']]
        end

        def verify(content)
          Display.info('message missing') unless content['message']
          Display.info('uid missing') unless content['uid']
        end
      end
    end
  end
end

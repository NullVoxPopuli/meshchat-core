# frozen_string_literal: true
require 'action_cable_client'

module Meshchat
  module Network
    module Remote
      class Relay
        # This channel is determine by the server, see
        # https://github.com/NullVoxPopuli/mesh-relay/blob/master/app/channels/mesh_relay_channel.rb
        CHANNEL = 'MeshRelayChannel'

        attr_reader :_url, :_client, :_request_processor, :_message_queue
        attr_accessor :_connected

        delegate :perform, to: :_client
        delegate :subscribed?, to: :_client

        def initialize(url, message_dispatcher, subscribed_callback = nil)
          @_url = url
          @_message_queue = []
          @_request_processor = Incoming::RequestProcessor.new(
            network: NETWORK_RELAY,
            location: url,
            message_dispatcher: message_dispatcher)

          setup(subscribed_callback: subscribed_callback)
        end

        def setup(subscribed_callback: nil)
          path = "#{_url}?uid=#{APP_CONFIG.user['uid']}"
          @_client = ActionCableClient.new(path, CHANNEL)

          # don't output anything upon connecting
          _client.connected do
            Debug.connected_to_relay
            self._connected = true
          end

          # If there are errors, report them!
          _client.errored do |message|
            process_error(message)
          end

          _client.subscribed do
            Debug.subscribed_to_relay
            subscribed_callback.call if subscribed_callback
          end

          # forward the encrypted messages to our RequestProcessor
          # so that they can be decrypted
          _client.received do |message|
            process_message(message)
          end

          _client.disconnected do
            Debug.disconnected_from_relay
            self._connected = false
          end

          _client
        end

        def send_now(payload)
          _client.perform('chat', payload)
        end

        def connected?
          _connected
        end

        # example messages:
        # {"identifier"=>"{\"channel\":\"MeshRelayChannel\"}", "message"=>{"message"=>"hi"}}
        # {"identifier"=>"{\"channel\":\"MeshRelayChannel\"}", "message"=>{"error"=>"hi"}}
        # {"identifier"=>"{\"channel\":\"MeshRelayChannel\"}", "type"=>"confirm_subscription"}
        # {"identifier"=>"{\"channel\":\"MeshRelayChannel\"}", "message"=>{"error"=>"Member with UID user2 could not be found"}}
        def process_message(message)
          Debug.received_message_from_relay(message, _url)

          _, type, message = message.values_at('identifier', 'type', 'message')

          # do we want to do anything here?
          return if type == 'confirm_subscription'
          # are there any other types of websocket messages?
          return unless message

          if message['message']
            chat_message_received(message)
          elsif message['error']
            error_message_received(message)
          end
        end

        # TODO: what does an error message look like?
        # TODO: what are situations in which we receive an error message?
        def process_error(message)
          Display.alert(message)
        end

        def chat_message_received(message)
          _request_processor.process(message)
        rescue => e
          ap e.message
          puts e.backtrace
        end

        def error_message_received(message)
          Display.info message['error']
          if message['status'] == 404
            uid = message['uid']
            mark_as_offline(uid)
          end
        end

        def mark_as_offline(uid)
          node = Node.find_by_uid(uid)
          if node
            Display.info "#{node.alias_name} has ventured offline"
            node.update(on_relay: false)
          else
            Display.info 'someone directly sent you a fake offline message'
          end
        end
      end
    end
  end
end

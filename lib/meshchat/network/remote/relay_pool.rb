# frozen_string_literal: true
module Meshchat
  module Network
    module Remote
      class RelayPool
        # This channel is determine by the server, see
        # https://github.com/NullVoxPopuli/mesh-relay/blob/master/app/channels/mesh_relay_channel.rb
        CHANNEL = 'MeshRelayChannel'

        attr_accessor :_message_dispatcher
        attr_accessor :_active_relay, :_waiting_for_subscription
        attr_accessor :_known_relays, :_available_relays
        attr_accessor :_message_queue

        def initialize(message_dispatcher)
          @_message_dispatcher = message_dispatcher
          @_known_relays = APP_CONFIG.user['relays'] || []
          @_available_relays = APP_CONFIG.user['relays'] || []
          @_message_queue = []

          find_initial_relay if @_known_relays.present?

          EM.add_periodic_timer(5) { ensure_relay }
        end

        # TODO: add logic for just selecting the first available relay.
        #       we only need one connection.
        # @return [Array] an array of action cable clients
        def find_initial_relay
          url = _known_relays.first
          self._waiting_for_subscription = true
          @_active_relay = Relay.new(url, _message_dispatcher, lambda do
            self._waiting_for_subscription = false
            deplete_queue
          end)
        end

        # @param [Hash] payload - the message payload
        def send_payload(payload)
          return if _active_relay.blank?
          _message_queue << payload
          ensure_connection do
            deplete_queue
          end
        end

        def deplete_queue
          until _message_queue.empty?
            if _active_relay.subscribed?
              payload = _message_queue.pop
              _active_relay.send_now(payload)
            end
          end
        end

        def ensure_connection
          if _active_relay.connected? && _active_relay.subscribed?
            yield
          else
            # if the relay isn't already connected,
            # it'll be built with a callback to deplete the queue
            ensure_relay
          end
        end

        def ensure_relay
          return if _waiting_for_subscription
          return if _active_relay.subscribed?
          return if _active_relay.connected?

          # clear the previous node
          _active_relay = nil
          # re-connect
          find_initial_relay
        end
      end
    end
  end
end

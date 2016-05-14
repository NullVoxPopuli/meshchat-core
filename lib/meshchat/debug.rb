# frozen_string_literal: true
module Meshchat
  # This file is stupid.
  # But very helpful when debugging problems...
  module Debug
    module_function

    # TODO: extract this idea to a gem
    #       - automatic logging of method calls
    def log(method_list)
      method_list = Array[method_list]
      method_list.each do |method|
        backup_name = "#{method}_bak".to_sym
        alias_method :backup_name, :method
        define_method(method) do |*args|
          Display.debug("##{method}: ")
          Display.debug(args.inspect)
        end
      end
    end

    def message_type_not_found(type)
      Display.debug('Type not found: ' + type.to_s)
    end

    def not_on_local_network(node)
      Display.debug('SENDING: ' + node.alias_name + ' is not on the local network')
    end

    def subscribed_to_relay
      Display.debug('Subscribed to relay...')
    end

    def connected_to_relay
      Display.debug('Connected to relay...')
    end

    def disconnected_from_relay
      Display.debug('Disconnected from relay...')
    end

    def received_message_from_relay(message, relay_url)
      Display.debug('RECEIVING on RELAY: ' + relay_url)
      Display.debug('RECEIVING on RELAY: ')
      Display.debug(message)
    end

    def sending_message_over_relay(node, relay_pool)
      Display.debug('SENDING on RELAY ---------------------- ')
      Display.debug('SENDING on RELAY: ' + node.alias_name)
      Display.debug('SENDING on RELAY: ' + node.uid)
      Display.debug('SENDING on RELAY: ' + relay_pool._active_relay._url)
    end

    def receiving_message(message)
      Display.debug('RECEIVING: ' + message.type)
      Display.debug('RECEIVING: ' + message.sender.to_s)
      Display.debug('RECEIVING: ' + message.message.to_s)
    end

    def message_being_dispatched(node, message)
      Display.debug('DISPATCHING: ---------------------')
      Display.debug('DISPATCHING: u - ' + node.uid)
      Display.debug('DISPATCHING: a - ' + node.alias_name)
      Display.debug('DISPATCHING: r - ' + node.on_relay.to_s)
      Display.debug('DISPATCHING: l - ' + node.on_local_network.to_s)
      Display.debug('DISPATCHING: ' + message.type)
      Display.debug('DISPATCHING: ' + message.message.to_s)
    end

    def person_not_online(node, message, e)
      Display.debug("#{message.class.name}: Issue connectiong to #{node.alias_name}@#{node.location}")
      Display.debug(e.message)
    end

    def encryption_failed(node)
      Display.info "Public key encryption for #{node.try(:alias_name) || 'unknown'} failed"
    end

    def creating_input_failed(e)
      Display.error e.message
      Display.error e.backtrace.join("\n").colorize(:red)
    end
  end
end

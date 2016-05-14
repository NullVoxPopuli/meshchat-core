# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      class Whisper < Command::Base
        attr_accessor :_target_node

        def self.description
          'sends a private message to a spepcific person'
        end

        def target
          # get first arg
          return _target_node.alias_name if _target_node
          command
        end

        def message
          return _input if _target_node
          command_args[1..command_args.length].try(:join, ' ')
        end

        def handle
          return send_message_to_node(_target_node) if _target_node
          find_node_and_whisper(target)
        end

        def send_message_to_node(node)
          m = _message_factory.create(
            Network::Message::WHISPER,
            data: {
              message: message,
              to: target
            }
          )

          Display.whisper m.display

          _message_dispatcher.send_message(node: node, message: m)
        end

        def find_node_and_whisper(target)
          NodeFinder.find_by_target(target) do |node|
            if node
              send_message_to_node(node)
            else
              Display.alert "node for #{target} not found or is not online"
            end
          end
        end
      end
    end
  end
end

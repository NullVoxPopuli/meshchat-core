# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      class Whisper < Command::Base
        def self.description
          'sends a private message to a spepcific person'
        end

        def target
          # get first arg
          command
        end

        def message
          command_args[1..command_args.length].try(:join, ' ')
        end

        def handle
          node = find_node(target)
          return if node.is_a?(Proc)

          if node
            send_message_to_node(node)
          else
            Display.alert "node for #{target} not found or is not online"
          end
        end

        def send_message_to_node(node)
          m = _message_factory.create(
            Network::Message::WHISPER,
            data: {
              message: message,
              to: target
            })

          Display.whisper m.display

          _message_dispatcher.send_message(node: node, message: m)
        end

        def find_node(target)
          nodes = Node.where(alias_name: target)
          return if nodes.length == 0
          return nodes.first if nodes.length == 1

          # there are now more than 1 nodes
          Display.warning I18n.t('node.multiple_with_alias', name: target)
          display_nodes(nodes)

          # insert a callback into the input handler to run the next
          # time a line is received
          #
          # TODO: this feels gross, is there a better way?
          # TODO: move this callback from ReadlineInput to the Input Base
          CLI::ReadlineInput.input_handler.callback_on_next_tick = lambda do |line|
            answer = line.to_i
            node = nodes[answer]
            send_message_to_node(node)
          end
        end

        def display_nodes(nodes)
          # write header
          Display.info "\t\t     UID      Last Seen"
          Display.info '-' * 60

          # write nodes
          nodes.each_with_index do |node, index|
            i = index.to_s
            alias_name = node.alias_name
            uid = node.uid[0..5]
            last_seen = node.updated_at&.strftime('%B %e, %Y  %H:%M:%S') || 'never'
            line = "%-2s | %-15s %-8s %s" % [i, alias_name, uid, last_seen]
            Display.info line
          end
        end
      end
    end
  end
end

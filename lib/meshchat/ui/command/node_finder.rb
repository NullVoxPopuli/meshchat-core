module Meshchat
  module Ui
    module Command
      module NodeFinder
        module_function

        def find_by_target(string, &block)
          search_key = string.start_with?('#') ? :uid : :alias_name
          nodes = Node.where(search_key => string)
          if nodes.length == 0
            return Display.warning('No node by: ' + string)
          end

          return block.call(nodes.first) if nodes.length == 1

          Display.warning I18n.t('node.multiple_with_alias', name: string)
          ask_for_specification(nodes, block)
        end

        def ask_for_specification(nodes, block)
          # there are now more than 1 nodes
          display_nodes(nodes)


          # insert a callback into the input handler to run the next
          # time a line is received
          #
          # TODO: this feels gross, is there a better way?
          # TODO: move this callback from ReadlineInput to the Input Base
          CLI::ReadlineInput.input_handler.callback_on_next_tick = lambda do |line|
            answer = line.to_i
            node = nodes[answer]
            # finally, send the mesasge
            # (or do whatever this is)
            # but usually, it sending the message
            block.call(node)
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

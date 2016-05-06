# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      class Chat < Command::Base
        def handle
          servers = Node.online
          if !servers.empty?
            type = self.class.name.demodulize.downcase
            m = _message_factory.create(type, data: { message: _input })
            show_myself(m)

            servers.each do |entry|
              _message_dispatcher.send_message(node: entry, message: m)
            end
          else
            Display.warning 'you have no servers'
          end
        end

        def show_myself(message)
          Display.chat message.display
        end
      end
    end
  end
end

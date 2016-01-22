module MeshChat
  class Command
    class Chat < Command::Base
      def handle
        servers = Node.online
        if !servers.empty?
          m = corresponding_message_class.new(
            message: _input
          )

          show_myself(m)

          # if sending to all, iterate thorugh list of
          # servers, and send to each one
          # TODO: do this async so that one server doesn't block
          # the rest of the servers from receiving the messages
          servers.each do |entry|
            Net::Client.send(node: entry, message: m)
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

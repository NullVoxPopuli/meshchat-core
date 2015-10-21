module MeshChat
  class CLI
    class PingAll < Command::Base
      def handle
        Node.all.each do |n|
          Net::Client.send(node: n, message: Message::Ping.new)
        end
      end
    end
  end
end

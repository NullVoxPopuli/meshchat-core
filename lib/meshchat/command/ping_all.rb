module MeshChat
  class Command
    class PingAll < Command::Base
      def self.description
        'pings all known users'
      end

      def handle
        Node.all.each do |n|
          Net::Client.send(node: n, message: Message::Ping.new)
        end
      end
    end
  end
end

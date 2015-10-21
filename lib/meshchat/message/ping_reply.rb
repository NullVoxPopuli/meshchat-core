module MeshChat
  module Message
    class PingReply < Base
      def display
        'ping successful'.freeze
      end
    end
  end
end

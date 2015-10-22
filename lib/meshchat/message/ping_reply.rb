module MeshChat
  module Message
    class PingReply < Base
      def display
        'ping successful'.freeze if Settings.debug?
      end
    end
  end
end

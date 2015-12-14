module MeshChat
  class Command
    class StopListening < Command::Base
      def self.description
        'prevents incoming messages'
      end

      def handle
        CLI.close_server
      end
    end
  end
end

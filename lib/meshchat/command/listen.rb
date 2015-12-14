module MeshChat
  class Command
    class Listen < Command::Base
      def self.description
        'starts listening for messages'
      end

      def handle
        CLI.start_server
      end
    end
  end
end

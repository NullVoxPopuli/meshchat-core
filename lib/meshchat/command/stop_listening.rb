module MeshChat
  class Command
    class StopListening < Command::Base
      def handle
        CLI.close_server
      end
    end
  end
end

module MeshChat
  class CLI
    class StopListening < Command::Base
      def handle
        CLI.close_server
      end
    end
  end
end

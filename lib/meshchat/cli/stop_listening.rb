module MeshChat
  class CLI
    class StopListening < CLI::Command
      def handle
        CLI.close_server
      end
    end
  end
end

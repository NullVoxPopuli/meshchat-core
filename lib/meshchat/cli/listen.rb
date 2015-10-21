module MeshChat
  class CLI
    class Listen < CLI::Command
      def handle
        CLI.start_server
      end
    end
  end
end

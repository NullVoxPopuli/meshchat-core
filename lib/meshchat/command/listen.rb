module MeshChat
  class CLI
    class Listen < Command::Base
      def handle
        CLI.start_server
      end
    end
  end
end

module MeshChat
  class Command
    class Listen < Command::Base
      def handle
        CLI.start_server
      end
    end
  end
end

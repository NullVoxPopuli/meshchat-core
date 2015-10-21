module MeshChat
  class CLI
    class Exit < Command::Base
      def handle
        CLI.shutdown
      end
    end
  end
end

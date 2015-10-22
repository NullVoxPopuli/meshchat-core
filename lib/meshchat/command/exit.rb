module MeshChat
  class Command
    class Exit < Command::Base
      def handle
        CLI.shutdown
      end
    end
  end
end

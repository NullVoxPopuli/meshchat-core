module MeshChat
  class CLI
    class Share < Command::Base
      def handle
        Settings.share
      end
    end
  end
end

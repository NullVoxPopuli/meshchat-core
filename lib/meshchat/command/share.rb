module MeshChat
  class Command
    class Share < Command::Base
      def handle
        Settings.share
      end
    end
  end
end

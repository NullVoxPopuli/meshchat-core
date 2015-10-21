module MeshChat
  class CLI
    class Identity < Command::Base
      def handle
        Display.success Settings.identity
      end
    end
  end
end

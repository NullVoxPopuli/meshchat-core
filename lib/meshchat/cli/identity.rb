module MeshChat
  class CLI
    class Identity < CLI::Command
      def handle
        Display.success Settings.identity
      end
    end
  end
end

module MeshChat
  class CLI
    class Base
      # override this to alter how input is gathered
      #
      # the returned value of this method should be a whole line / command
      # that will be passed to MeshChat::CLI.create_input
      def get_input
        gets
      end
    end
  end
end

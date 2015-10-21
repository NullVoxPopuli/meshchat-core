module MeshChat
  class CLI
    class Base

      class << self
        def autocompletes
          commands = COMMAND_MAP.map{ |k, v| "/#{k}" }
          aliases = MeshChat::Node.all.map{ |n| "#{n.alias_name}" }
          commands + aliases
        end
      end

      def initalize
        # Set up auto complete
        completion = proc{ |s| self.class.autocompletes.grep(/^#{Regexp.escape(s)}/) }
        Readline.completion_proc = completion
      end

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

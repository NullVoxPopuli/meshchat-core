module MeshChat
  class CLI
    class Input
      WHISPER = '@'
      COMMAND = '/'
      attr_accessor :_input

      class << self
        def is_command?(input)
          input[0, 1] == COMMAND
        end

        def is_whisper?(input)
          input[0, 1] == WHISPER
        end

        def create(input)
          klass =
            if is_command?(input)
              Command::Base
            elsif is_whisper?(input)
              Command::Whisper
            else
              Command::Chat
            end

          Display.debug("INPUT: Detected '#{klass.name}' from '#{input}'")
          klass.new(input)
        end
      end

      def initialize(input)
        self._input = input.chomp
      end
    end
  end
end

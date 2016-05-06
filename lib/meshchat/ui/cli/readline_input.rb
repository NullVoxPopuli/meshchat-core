require 'readline/callback'

# frozen_string_literal: true
module Meshchat
  module Ui
    class CLI
      class ReadlineInput
        # The class used for interpeting the line input
        attr_reader :_input_receiver

        def initialize(input_receiver)
          @_input_receiver = input_receiver
        end

        module Handler

          def initialize
            Readline.callback_handler_install('> ') do |line|
              EventMachine.next_tick { @input_receiver.create_input(line) }
            end
          end

          def notify_readable
            Readline.callback_read_char
          end

          def unbind
            Readline.callback_handler_remove
          end

          def input_receiver=(receiver)
            @input_receiver = receiver
          end

        end

        class << self
          def autocompletes
            commands = Meshchat::Ui::Command::COMMAND_MAP.map { |k, _v| "/#{k}" }
            aliases = Meshchat::Node.all.map { |n| "#{n.alias_name}" }
            commands + aliases
          end
        end

        def start
          # Ripl.start

          conn = EventMachine.watch $stdin, Handler
          conn.notify_readable = true
          conn.input_receiver = _input_receiver

          # update auto completion
          completion = proc { |s| self.class.autocompletes.grep(/^#{Regexp.escape(s)}/) }
          Readline.completion_proc = completion
        end

        # def initialize(*args)
        #   super(args)
        #
        #
        # end

        # called every time meshchat wants a line of text from the user
        # def get_input
        #   # update auto completion
        #   completion = proc { |s| self.class.autocompletes.grep(/^#{Regexp.escape(s)}/) }
        #   Readline.completion_proc = completion
        #
        #   Readline.readline('> ', true)
        # end

      end
    end
  end
end

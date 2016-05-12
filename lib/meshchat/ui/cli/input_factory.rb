# frozen_string_literal: true
module Meshchat
  module Ui
    class CLI
      class InputFactory
        WHISPER = '@'
        COMMAND = '/'

        attr_accessor :_message_dispatcher, :_message_factory, :_cli
        attr_accessor :_whisper_lock_target

        def initialize(message_dispatcher, message_factory, cli)
          self._message_dispatcher = message_dispatcher
          self._message_factory    = message_factory
          self._cli                = cli
        end

        def is_command?(input)
          input[0, 1] == COMMAND
        end

        def is_whisper?(input)
          input[0, 1] == WHISPER
        end

        def create(for_input: nil, with_class: nil)
          return create_with_class(for_input, with_class) if with_class

          create_for_input(for_input)
        end

        def create_with_class(input, klass)
          klass.new(input, _message_dispatcher, _message_factory, self)
        end

        def clear_whisper_lock
          self._whisper_lock_target = nil
        end

        def whisper_lock_to(node)
          self._whisper_lock_target = node
        end

        def create_for_input(input)
          klass =
            if is_command?(input)
              Command::Base
            elsif is_whisper?(input)
              Command::Whisper
            else
              return whisper_for_locked_target(input) if _whisper_lock_target
              Command::Chat
            end

          create_with_class(input, klass)
        end

        def whisper_for_locked_target(input)
          command = Command::Whisper.new(
            input, _message_dispatcher, _message_factory, self)

          command._target_node = _whisper_lock_target
          command
        end
      end
    end
  end
end

# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      class WhisperLock < Command::Base
        def self.description
          'sets the current chat to to a chosen person'
        end

        def target
          # get first arg
          command_args[1]
        end

        def handle
          NodeFinder.find_by_target(target) do |node|
            Display.info "whisper-locked to #{node.alias_name}##{node.uid}"
            _input_factory.whisper_lock_to(node)
          end
        end
      end
    end
  end
end

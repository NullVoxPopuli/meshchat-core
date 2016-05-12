# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      class AllChatLock < Command::Base
        def self.description
          'sets the current chat to the "All Chat"'
        end

        def handle
          Display.info 'whisper lock disabled'
          _input_factory.clear_whisper_lock
        end
      end
    end
  end
end

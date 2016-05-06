# frozen_string_literal: true
module Meshchat
  module Network
    module Message
      class PingReply < Base
        def display
          super.merge(message: 'successfully responded to your ping')
        end
      end
    end
  end
end

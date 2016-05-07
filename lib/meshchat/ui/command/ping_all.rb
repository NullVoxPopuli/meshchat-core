# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      class PingAll < Command::Base
        def self.description
          'pings all known users'
        end

        def handle
          ping = _message_factory.create(Network::Message::PING)
          _message_dispatcher.send_to_all(ping, ignore_offline_status: true)
        end
      end
    end
  end
end

# frozen_string_literal: true
module Meshchat
  module Ui
    # A user interface is responsible for for creating a client
    # and sending messages to that client
    class CLI
      extend ActiveSupport::Autoload

      # 60 seconds times 5 minutes
      AWAY_TIMEOUT = 60 * 5

      eager_autoload do
        autoload :InputFactory
        autoload :Base
        autoload :KeyboardLineInput
        autoload :ReadlineInput
      end

      attr_reader :_message_dispatcher, :_message_factory, :_command_factory
      attr_accessor :_last_input_received_at
      attr_accessor :_sent_idle_message

      def initialize(dispatcher, message_factory, _display)
        @_message_dispatcher = dispatcher
        @_message_factory = message_factory
        @_command_factory = InputFactory.new(dispatcher, message_factory, self)
        self._sent_idle_message = false
        self._last_input_received_at = Time.now

        # only check for timeout once a minute
        EM.add_periodic_timer(60) { away_timeout }
      end

      def away_timeout
        return unless activity_timeout_triggred?
        message = _message_factory.create(Network::Message::EMOTE,
          data: {
            message: 'has become idle'
          })

        _message_dispatcher.send_to_all(message)
        self._sent_idle_message = true
      end

      def activity_timeout_triggred?
        return false if _sent_idle_message
        seconds_passed = Time.now - _last_input_received_at
        seconds_passed > AWAY_TIMEOUT
      end

      def reset_timeout_timer
        self._last_input_received_at = Time.now
        self._sent_idle_message = false
      end

      def create_input(msg)
        reset_timeout_timer
        handler = _command_factory.create(for_input: msg)
        handler.handle
      rescue => e
        Debug.creating_input_failed(e)
      end

      # save config and exit
      def shutdown
        # close_server
        Display.info 'saving config...'
        APP_CONFIG.user.save
        Display.info 'notifying of disconnection...'
        send_disconnect
        Display.alert "\n\nGoodbye.  \n\nThank you for using #{Meshchat.name}"
        exit
      end

      def send_disconnect
        klass   = Command::SendDisconnect
        command = _command_factory.create(with_class: klass)
        command.handle
      end
    end
  end
end

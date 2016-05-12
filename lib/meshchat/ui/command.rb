# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      extend ActiveSupport::Autoload

      eager_autoload do
        autoload :Base
        autoload :Chat
        autoload :Emote
        autoload :Whisper
        autoload :WhisperLock
        autoload :AllChatLock

        autoload :Identity
        autoload :Irb
        autoload :Config
        autoload :Ping
        autoload :PingAll
        autoload :Server
        autoload :Exit
        autoload :SendDisconnect
        autoload :Help
        autoload :Bind
        autoload :Online
        autoload :Offline
        autoload :Share
        autoload :Import
        autoload :Roll

        # Utility
        autoload :NodeFinder
      end

      COMMAND_MAP = {
        Base::CONFIG          => Config,
        Base::PING            => Ping,
        Base::PING_ALL        => PingAll,
        Base::SERVERS         => Server,
        Base::SERVER          => Server,
        Base::EXIT            => Exit,
        Base::QUIT            => Exit,
        Base::IDENTITY        => Identity,
        Base::IRB             => Irb,
        Base::SHARE           => Share,
        Base::IMPORT          => Import,
        Base::EXPORT          => Share,
        Base::ONLINE          => Online,
        Base::OFFLINE         => Offline,
        Base::HELP            => Help,
        Base::BIND            => Bind,
        Base::SEND_DISCONNECT => SendDisconnect,
        Base::EMOTE           => Emote,
        Base::ROLL            => Roll,
        Base::CHAT            => Chat,
        Base::WHISPER_LOCK    => WhisperLock,
        Base::ALL_CHAT_LOCK   => AllChatLock
      }.freeze
    end
  end
end

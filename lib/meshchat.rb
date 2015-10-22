# required standard libs
require 'openssl'
require 'socket'
require 'json'
require 'date'
require 'colorize'
require 'curses'
require 'io/console'
require "readline"

require 'logger'

# required gems
require 'awesome_print'
require 'sqlite3'
require 'active_record'
require 'curb'
require 'thin'
require 'libnotify'

# active support extensions
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'

# local files for meshchat
require 'meshchat/version'
require 'meshchat/database'
require 'meshchat/instance'
require 'meshchat/encryption'
require 'meshchat/display'
require 'meshchat/display/manager'
require 'meshchat/notifier/base'
require 'meshchat/models/entry'
require 'meshchat/config/hash_file'
require 'meshchat/config/settings'
require 'meshchat/net/request'
require 'meshchat/net/client'
require 'meshchat/net/listener/request'
require 'meshchat/net/listener/request_processor'
require 'meshchat/net/listener/server'
require 'meshchat/cli'
require 'meshchat/message'

module MeshChat
  NAME = 'MeshChat'
  Settings = Config::Settings
  Node = Models::Entry
  Cipher = Encryption
  Notify = Notifier::Base

  module_function

  # @param [Hash] overrides
  # @option overrides [Proc] on_display_start what to do upon start of the display manager
  # @option overrides [class] display the display ui to use inherited from Display::Base
  def start(overrides = {})
    defaults = {
      display: Display::Base,
      client_name: NAME,
      client_version: VERSION,
      input: CLI::Base
    }
    options = defaults.merge(overrides)

    # before doing anything, ensure we have a place to store data
    Database.setup_storage
    # set the options / overrides!
    Instance.start(options)
  end

  def name; Instance.client_name; end
  def version; Instance.client_version; end
end

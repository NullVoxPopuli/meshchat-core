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
      client_version: VERSION
    }
    options = defaults.merge(overrides)

    # before doing anything, ensure we have a place to store data
    setup_storage

    # set the options / overrides!
    new_ui(options[:display], options[:on_display_start])
    set_client_info(options[:client_name], options[:client_version])
  end

  # @param [class] klass should be something that implements Display::Base
  # @param [Proc] proc what to do when starting the UI
  def new_ui(klass, on_display_start)
    @@display = Display::Manager.new(klass)
    @@display.start do
      on_display_start.call if on_display_start
    end
  end

  def set_client_info(name, version)
    @@name = name
    @@version = version
  end

  def name; @@name; end
  def version; @@version; end
  def ui; @@display; end


  # Upon initial startup, instantiated the database
  # this is used for storing the information of every node
  # on the network
  def setup_storage
    ActiveRecord::Base.establish_connection(
        adapter: "sqlite3",
        database: "meshchat.sqlite3",
        pool: 128
    )

    ActiveRecord::Migration.suppress_messages do
      ActiveRecord::Schema.define do
        unless table_exists? :entries
          create_table :entries do |table|
            table.column :alias_name, :string
            table.column :location, :string
            table.column :uid, :string
            table.column :public_key, :string
            table.column :online, :boolean, default: true, null: false
          end
        end
      end
    end
  end

end

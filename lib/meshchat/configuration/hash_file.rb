# frozen_string_literal: true
module Meshchat
  module Configuration
    class HashFile
      attr_accessor :_hash

      DEFAULT_SETTINGS = {}.freeze

      def initialize
        self._hash = default_settings.dup
        exists? ? load : save
      end

      def [](key)
        _hash[key.to_s]
      end

      def []=(key, value)
        _hash[key.to_s] = value
      end

      def load
        f = read_file
        begin
          self._hash = JSON.parse(f)
        rescue => e
          Display.alert e.message
          self._hash = default_settings
          Display.warning 'writing defaults...'
          save
        end
      end

      def read_file
        File.read(filename)
      end

      def display
        _hash.inspect
      end

      def as_hash
        _hash
      end

      def save
        # backup
        exists = exists?
        File.rename(filename, filename + '.bak') if exists
        # write
        File.open(filename, 'w') { |f| f.syswrite(_hash.to_json) }
        # remove backup
        File.delete(filename + '.bak') if exists
      end

      def set(key, with: value)
        self[key] = with
        save
        "#{key} set to #{with}"
      end

      def exists?
        File.exist?(filename)
      end

      def filename
        return @filename if @filename
        raise 'filename must be set'
      end

      def default_settings
        @default_settings ? @default_settings : DEFAULT_SETTINGS
      end
    end
  end
end

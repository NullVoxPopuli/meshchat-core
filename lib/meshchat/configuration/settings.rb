# frozen_string_literal: true
module Meshchat
  module Configuration
    class Settings < HashFile
      FILENAME = 'settings.json'

      DEFAULT_SETTINGS = {
        'alias' => '',
        'port' => '8009',
        'ip' => 'localhost',
        'uid' => '',
        'publickey' => '',
        'relays' => [
          'wss://mesh-relay-in-us-1.herokuapp.com',
          'wss://mesh-relay-us-2.herokuapp.com'
        ]
      }.freeze

      def debug?
        %w(true 1 yes y t).include?(self['debug'].try(:downcase))
      end

      def identity_as_json
        {
          'alias' => self['alias'],
          'location' => location,
          'uid' => self['uid'],
          'publickey' => self['publickey']
        }
      end

      def save
        self._hash = DEFAULT_SETTINGS.merge(_hash)
        super
      end

      def share
        data = identity_as_json.to_json

        filename = "#{identity_as_json['alias']}.json"
        File.open(filename, 'w') { |f| f.syswrite(data) }
        Display.info "#{filename} written..."
      end

      def keys_exist?
        public_key.present? && private_key.present?
      end

      def uid_exists?
        self['uid'].present?
      end

      def public_key
        return unless (key = self['publickey']).present?
        @public_key ||= Encryption.public_key_from_base64(key)
      end

      def private_key
        return unless (key = self['privatekey']).present?
        @private_key ||= Encryption.private_key_from_base64(key)
      end

      # generates 32 bytes
      def generate_uid
        self['uid'] = SecureRandom.hex(32)
        Display.success 'new uid set'
      end

      def generate_keys
        pubilc_key, private_key = Encryption.generate_keys
        self['publickey'] = to_base64(pubilc_key)
        self['privatekey'] = to_base64(private_key)
        Display.success 'new keys generated'
      end

      def identity
        "#{self['alias']}@#{location}##{self['uid']}"
      end

      def location
        "#{self['ip']}:#{self['port']}"
      end

      def initialize
        @default_settings = DEFAULT_SETTINGS
        @filename = FILENAME
        super
      end

      def valid?
        errors.empty?
      end

      def errors
        messages = []
        messages << 'must have an alias' unless self['alias'].present?
        # messages << 'must have ip set' unless self['ip'].present?
        # messages << 'must have port set' unless self['port'].present?
        messages << 'must have uid set' unless self['uid'].present?
        messages
      end

      def is_complete?
        valid? && self['privatekey'] && self['publickey']
      end

      # for NaCl, this is simple because the public and private key's to_s
      # method defines to_s as the byte string.
      #
      # for AES_RSA, the keys are already strings.
      #
      # So really, all that needs to be done is encode
      def to_base64(key)
        Base64.strict_encode64(key.to_s)
      end
    end
  end
end

# frozen_string_literal: true
require 'meshchat/encryption/aes_rsa'
require 'meshchat/encryption/passthrough'

module Meshchat
  module Encryption
    extend ActiveSupport::Autoload

    autoload :AES_RSA
    autoload :NaCl
    autoload :Passthrough

    module_function

    DEFAULT_ENCRYPTOR = NaCl

    def encryptor=(klass)
      @current_encryptor = klass
    end

    def current_encryptor
      @current_encryptor || DEFAULT_ENCRYPTOR
    end

    def generate_keys
      current_encryptor.generate_keys
    end

    def decrypt(*args)
      current_encryptor.decrypt(*args)
    end

    def encrypt(*args)
      current_encryptor.encrypt(*args)
    end

    def public_key_from_base64(base64)
      decoded = Base64.decode64(base64)
      current_encryptor.public_key_from_bytes(decoded)
    end

    def private_key_from_base64(base64)
      decoded = Base64.decode64(base64)
      current_encryptor.private_key_from_bytes(decoded)
    end
  end
end

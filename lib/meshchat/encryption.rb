require 'meshchat/encryption/aes_rsa'
require 'meshchat/encryption/passthrough'

module MeshChat
  module Encryption
    module_function

    DEFAULT_ENCRYPTOR = AES_RSA

    def encryptor=(klass)
      @current_encryptor = klass
    end

    def current_encryptor
      @current_encryptor || DEFAULT_ENCRYPTOR
    end

    def decrypt(*args)
      current_encryptor.decrypt(*args)
    end

    def encrypt(*args)
      current_encryptor.encrypt(*args)
    end

  end
end

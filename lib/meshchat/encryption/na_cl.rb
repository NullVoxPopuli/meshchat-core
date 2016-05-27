module Meshchat
  module Encryption
    # Recommended Algorithms from NaCl
    #
    # Encryption: XSalsa20 stream cipher
    # Authentication: Poly1305 MAC
    # Public Keys: Curve25519 high-speed elliptic curve cryptography
    #
    # XSalsa20 isn't exactly 'better' than AES, but it is much faster on
    # hardware that doesn't have native AES builtin
    #
    # The primary goal of using NaCl is to not use RSA. As all the padding
    # schemes are vulnerable.
    #
    # see:
    # https://github.com/cryptosphere/rbnacl/wiki/Public-Key-Encryption
    # for details on how this works
    module NaCl
      require 'rbnacl/libsodium'
      require 'rbnacl'

      PUBLIC_KEY_CLASS = RbNaCl::Boxes::Curve25519XSalsa20Poly1305::PublicKey
      PRIVATE_KEY_CLASS = RbNaCl::Boxes::Curve25519XSalsa20Poly1305::PrivateKey

      module_function

      # @param [String] msg - payload to be encrypted
      # @param [String|PublicKey] for_public_key - the public key of the intended recipient
      # @param [String|PrivateKey] with_private_key - (usually) our private key
      def encrypt(msg, for_public_key, with_private_key = nil)
        # encrypt using the box. The nonce is handled for us
        box = RbNaCl::SimpleBox.from_keypair(for_public_key, with_private_key)
        box.encrypt(msg)
      end

      # @param [String] msg - payload to be encrypted
      # @param [String|PublicKey] from_public_key - the public key of the intended recipient
      # @param [String|PrivateKey] with_private_key - (usually) our private key
      def decrypt(msg, from_public_key, with_private_key = nil)
        # decrypt using the box. The nonce is handled for us
        box = RbNaCl::SimpleBox.from_keypair(from_public_key, with_private_key)
        box.decrypt(msg)
      end

      # Generates Random Keys
      #
      # Pretty much only used when creating your identity
      def generate_keys
        private_key = RbNaCl::PrivateKey.generate
        public_key = private_key.public_key

        [public_key, private_key]
      end

      #############################
      # -- Conversion utilities --
      #
      # these are used for reading from and saving to settings files.
      #############################

      # pretty much just an alias for this rediculously long namespace
      # @return [RbNaCl::Boxes::Curve25519XSalsa20Poly1305::PrivateKey] from key
      def private_key_from_bytes(byte_string)
        PRIVATE_KEY_CLASS.new(byte_string)
      end

      # pretty much just an alias for this rediculously long namespace
      # @return [RbNaCl::Boxes::Curve25519XSalsa20Poly1305::PublicKey] from key
      def public_key_from_bytes(byte_string)
        PUBLIC_KEY_CLASS.new(byte_string)
      end
    end
  end
end

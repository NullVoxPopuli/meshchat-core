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

      module_function

      # @param [String] msg - payload to be encrypted
      # @param [String] for_public_key - the public key of the intended recipient
      # @param [String] with_private_key - (usually) our private key
      def encrypt(msg, for_public_key, with_private_key = nil)
        # encrypt using the box. The nonce is handled for us
        box = RbNaCl::SimpleBox.from_keypair(for_public_key, with_private_key)
        encrypted = box.encrypt(msg)
      end

      # @param [String] msg - payload to be encrypted
      # @param [String] from_public_key - the public key of the intended recipient
      # @param [String] with_private_key - (usually) our private key
      def decrypt(msg, from_public_key, with_private_key = nil)
        # decrypt using the box. The nonce is handled for us
        box = RbNaCl::SimpleBox.from_keypair(from_public_key, with_private_key)
        box.decrypt(msg)
      end
    end
  end
end

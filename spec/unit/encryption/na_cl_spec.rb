require 'spec_helper'

describe Meshchat::Encryption::NaCl do
  let(:klass) { Meshchat::Encryption::NaCl }

  before(:each) do
    @alice_private_key = RbNaCl::PrivateKey.generate
    @alice_public_key = @alice_private_key.public_key

    @bob_private_key = RbNaCl::PrivateKey.generate
    @bob_public_key = @bob_private_key.public_key
  end

  it 'has a message that can be decrypted' do
    ciphertext = klass.encrypt('hi', @bob_public_key, @alice_private_key)
    msg = klass.decrypt(ciphertext, @bob_public_key, @alice_private_key)
    expect(msg).to eq 'hi'
  end

  it 'encrypts and decrypts with a nonce' do
    alice_box = RbNaCl::Box.new(@bob_public_key, @alice_private_key)
    bob_box = RbNaCl::Box.new(@alice_public_key, @bob_private_key)

    # encrypt a message using the box.
    # First, make a nonce.  One simple strategy is to use 24 random bytes.
    # The nonce isn't secret, and can be sent with the ciphertext.
    # crypto_box provides the #nonce_bytes method for its nonce length.
    nonce = RbNaCl::Random.random_bytes(alice_box.nonce_bytes)

    message = { text: 'some message' }.to_json

    encrypted = alice_box.encrypt(nonce, message)
    decrypted_message = bob_box.decrypt(nonce, encrypted)

    expect(decrypted_message).to eq message
  end

  it 'encrypts and decrypts with a simplebox' do
    alice_box = RbNaCl::SimpleBox.from_keypair(@bob_public_key, @alice_private_key)
    bob_box = RbNaCl::SimpleBox.from_keypair(@alice_public_key, @bob_private_key)

    message = { text: 'some message' }.to_json

    encrypted = alice_box.encrypt(message)
    decrypted_message = bob_box.decrypt(encrypted)

    expect(decrypted_message).to eq message
  end
end

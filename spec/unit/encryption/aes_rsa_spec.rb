# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Encryption::AES_RSA do
  let(:klass) { Meshchat::Encryption::AES_RSA }

  before(:each) do
    @public_key, @private_key = klass.generate_keys
  end

  it 'has a message that can be decrypted' do
    message = 'message'
    encrypted = klass.encrypt(message, @public_key)
    decrypted = klass.decrypt(encrypted, nil, @private_key)

    expect(message).to eq decrypted
  end

  it 'encrypts a really long message' do
    message = 'message' * 100
    encrypted = klass.encrypt(message, @public_key)
    decrypted = klass.decrypt(encrypted, nil, @private_key)

    expect(message).to eq decrypted
  end

  it 'encrypts long json messages' do
    message = {
      hash1: SecureRandom.hex(1024),
      hash2: SecureRandom.hex(1024),
      hash3: SecureRandom.hex(3200)
    }.to_json

    encrypted = klass.encrypt(message, @public_key)
    decrypted = klass.decrypt(encrypted, nil, @private_key)

    expect(message).to eq decrypted
  end
end

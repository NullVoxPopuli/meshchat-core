require 'spec_helper'

describe Meshchat::Encryption::NaCl do
  let(:klass) { Meshchat::Encryption::NaCl }

  before(:each) do
    @alice_public_key, @alice_private_key = klass.generate_keys
    @bob_public_key, @bob_private_key = klass.generate_keys
  end

  it 'has a message that can be decrypted' do
    ciphertext = klass.encrypt('hi', @bob_public_key, @alice_private_key)
    msg = klass.decrypt(ciphertext, @bob_public_key, @alice_private_key)
    expect(msg).to eq 'hi'
  end

  it 'has a message that can be decrypted using string versions of the keys' do
    ciphertext = klass.encrypt('hi', @bob_public_key.to_s, @alice_private_key.to_s)
    msg = klass.decrypt(ciphertext, @bob_public_key.to_s, @alice_private_key.to_s)
    expect(msg).to eq 'hi'
  end

  it 'has a message that can be encrypted using strings, and decyrpted using the key objects' do
    ciphertext = klass.encrypt('hi', @bob_public_key.to_s, @alice_private_key.to_s)
    msg = klass.decrypt(ciphertext, @bob_public_key, @alice_private_key)
    expect(msg).to eq 'hi'
  end
end

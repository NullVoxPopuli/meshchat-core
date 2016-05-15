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
end

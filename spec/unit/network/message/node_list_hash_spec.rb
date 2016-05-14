# frozen_string_literal: true
require 'spec_helper'

describe Meshchat::Network::Message::NodeListHash do
  let(:klass) { Meshchat::Network::Message::NodeListHash }
  let(:message_dispatcher) { Meshchat::Network::Dispatcher.new }
  let(:message_factory) { message_dispatcher._message_factory }
  before(:each) do
    mock_settings_objects
    allow(message_dispatcher).to receive(:send_message) {}
    allow(message_dispatcher._local_client).to receive(:start_server)
  end

  context 'instantiation' do
    it 'sets a default payload' do
      msg = klass.new
      expect(msg.payload).to_not be_nil
    end
  end

  context '#handle' do
    it 'calls respond' do
      msg = klass.new(message: 'hash', message_dispatcher: message_dispatcher, message_factory: message_factory)
      expect(msg).to receive(:respond)
      expect(msg.handle).to be_nil
    end
  end

  context '#respond' do
    it 'sends a message if the hashes are different' do
      msg = klass.new(message: 'hash', message_dispatcher: message_dispatcher, message_factory: message_factory)
      expect(msg).to receive_message_chain(:_message_dispatcher, :send_message) {}
      msg.respond
    end
  end
end

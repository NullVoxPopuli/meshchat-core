require 'spec_helper'

describe MeshChat::Message::NodeList do
  let(:klass) { MeshChat::Message::NodeList }

  before(:each) do
    mock_settings_objects
  end

  context 'instantiation' do
    it 'sets a default payload' do
      msg = klass.new
      expect(msg.payload).to_not be_nil
    end
  end

  describe '#handle' do
    it 'calls respond' do
      msg = klass.new(message: 'hash')
      expect(msg).to receive(:respond)
      expect(msg.handle).to be_nil
    end
  end

  describe '#respond' do
    it 'sends a message' do
      expect(MeshChat::Net::Client).to receive(:send)

      expect(MeshChat::Models::Entry).to receive(:diff) {
        [[  {
            'alias' => 'hi',
            'location' => '2.2.2.2:222',
            'uid' => '222',
            'publickey' => '1233333'
          }], []]
      }

      msg = klass.new
      msg.respond
    end

    it 'sendsa  node list hash as confirmation that lists are in sync' do
      expect(MeshChat::Net::Client).to receive(:send)
      expect(MeshChat::Message::NodeListHash).to receive(:new)
      msg = klass.new
      msg.respond
    end
  end
end

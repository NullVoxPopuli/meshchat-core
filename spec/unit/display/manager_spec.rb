require 'spec_helper'

describe MeshChat::Display::Manager do
  let (:klass){ MeshChat::Display::Manager }

  before(:each) do
    allow(MeshChat::Net::Client).to receive(:send){}

    mock_settings_objects
  end

  describe '#present_message' do

    it 'invokes chat' do
      expect(MeshChat::Instance.display).to receive(:chat)
      m = MeshChat::Message::Chat.new
      MeshChat::Display.present_message(m)
    end

    it 'invokes whisper' do
      expect(MeshChat::Instance.display).to receive(:whisper)
      m = MeshChat::Message::Whisper.new
      MeshChat::Display.present_message(m)
    end

    it 'invokes info' do
      pending 'output disabled for pingreply'
      expect(MeshChat::Instance.display).to receive(:info)
      m = MeshChat::Message::PingReply.new
      MeshChat::Display.present_message(m)
    end

    it 'invokes add_line for other menssages' do
      expect(MeshChat::Instance.display).to receive(:add_line)
      m = MeshChat::Message::Disconnection.new
      MeshChat::Display.present_message(m)
    end
  end

end

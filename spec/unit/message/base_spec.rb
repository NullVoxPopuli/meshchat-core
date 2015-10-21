require 'spec_helper'

describe MeshChat::Message::Base do
  let(:klass) { MeshChat::Message::Base }

  before(:each) do
    mock_settings_objects
  end

  describe '#display' do
    it 'shows the message' do
      m = klass.new
      expect(m.display).to eq nil # no message
    end
  end

  describe '#new' do
    it 'has my sender defaults' do
      m = klass.new
      expect(m.sender_name).to eq MeshChat::Settings['alias']
      expect(m.sender_location).to eq MeshChat::Settings.location
      expect(m.sender_uid).to eq MeshChat::Settings['uid']
    end
  end

end

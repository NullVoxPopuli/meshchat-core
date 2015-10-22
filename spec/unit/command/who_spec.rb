require 'spec_helper'

describe MeshChat::Command::Who do
  let (:klass){ MeshChat::Command::Who }

  before(:each) do
    mock_settings_objects
  end


  describe '#handle' do
    it 'alerts the user' do
      c = klass.new('/who')
      #expect(c.handle).to eq MeshChat::ActiveServers.who
    end
  end

end

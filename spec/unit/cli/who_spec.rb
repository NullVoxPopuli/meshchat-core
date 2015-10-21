require 'spec_helper'

describe MeshChat::CLI::Who do
  let (:klass){ MeshChat::CLI::Who }

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

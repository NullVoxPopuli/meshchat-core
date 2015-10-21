require 'spec_helper'

describe MeshChat::CLI::Server do
  let (:klass){ MeshChat::CLI::Server }

  before(:each) do
    mock_settings_objects
  end

  describe '#handle' do

    it 'shows who is online' do
      c = klass.new('/server online')
      #expect(c.handle).to eq MeshChat::ActiveServers.display_locations
    end

    it 'lists the locations' do
      c = klass.new('/servers')
      #expect(c.handle).to eq MeshChat::ActiveServers.display_locations
    end


  end

end

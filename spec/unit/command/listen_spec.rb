require 'spec_helper'

describe MeshChat::Command::Listen do
  let (:klass){ MeshChat::Command::Listen }

  before(:each) do
    mock_settings_objects
  end


  describe '#handle' do
    it 'alerts the user' do
      # prevent the server from actually running
      expect(MeshChat::CLI).to receive(:start_server)
      c = klass.new('/listen')
      expect(c.handle).to eq nil
    end
  end

end

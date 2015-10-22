require 'spec_helper'

describe MeshChat::Command::Identity do
  let (:klass){ MeshChat::Command::Identity }

  before(:each) do
    mock_settings_objects
  end


  describe '#handle' do
    it 'alerts the user' do
      c = klass.new('/identity')
      # there isn't really a beneficial way to test this,
      # but it does make sure that there are no errors
      expect(c.handle).to eq MeshChat::Settings.identity
    end
  end

end

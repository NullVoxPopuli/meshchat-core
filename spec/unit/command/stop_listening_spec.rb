require 'spec_helper'

describe MeshChat::Command::StopListening do
  let (:klass){ MeshChat::Command::StopListening }

  before(:each) do
    mock_settings_objects
  end


  describe '#handle' do
    it 'alerts the user' do
      c = klass.new('/stoplistening')
      expect(c.handle).to eq nil
    end
  end

end

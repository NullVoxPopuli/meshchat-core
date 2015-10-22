require 'spec_helper'

describe MeshChat::Command::Exit do
  let (:klass){ MeshChat::Command::Exit }

  before(:each) do
    mock_settings_objects
  end


  describe '#handle' do
    it 'alerts the user' do
      # don't actually shut down...
      expect(MeshChat::CLI).to receive(:shutdown)
      c = klass.new('/exit')
      c.handle
    end
  end

end

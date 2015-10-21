require 'spec_helper'

describe MeshChat::CLI::Exit do
  let (:klass){ MeshChat::CLI::Exit }

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

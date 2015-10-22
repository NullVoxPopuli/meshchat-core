require 'spec_helper'

describe MeshChat::Command::IRB do
  let (:klass){ MeshChat::Command::IRB }

  before(:each) do
    mock_settings_objects
  end


  describe '#handle' do
    it 'alerts the user' do
      # don't actually shut down...
      expect(MeshChat::Models::Entry).to receive(:first)
      c = klass.new('/c Node.first')
      c.handle
    end
  end

end

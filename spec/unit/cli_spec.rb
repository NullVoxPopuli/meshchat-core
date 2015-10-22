require 'spec_helper'

describe MeshChat::CLI do
  let(:klass) { MeshChat::CLI }

  before(:each) do
    mock_settings_objects
  end

  context 'initialize' do
    it 'does not error' do
      expect do
        klass.new
      end.to_not raise_error
    end
  end

  describe '#listen_for_commands' do
    it 'creates an input' do
      cli = klass.new
      allow(cli._input_device).to receive(:get_input) { 'chat message' }
      expect_any_instance_of(MeshChat::CLI::Input).to receive(:handle) {}
      cli.process_input
    end
  end
end

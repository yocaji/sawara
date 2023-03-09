# frozen_string_literal: true

require 'sawara/user_config'

RSpec.describe Sawara::UserConfig do
  let(:config_path) { "#{Dir.home}/.sawara.yml" }
  let(:user_config) do
    {
      'api_key' => 'test_api_key',
      'bots' => { 'bot1' => { 'name' => 'Bot1', 'prompt' => 'This is a prompt for Bot1.' } }
    }
  end

  describe '.read' do
    context 'when config file does not exist' do
      before do
        allow(File).to receive(:exist?).with(config_path).and_return(false)
        allow(Sawara::UserConfig).to receive(:create_config_file)
      end

      it 'creates a new config file' do
        expect(Sawara::UserConfig).to receive(:create_config_file)
        Sawara::UserConfig.read
      end
    end

    context 'when config file exists' do
      before do
        allow(File).to receive(:exist?).with(config_path).and_return(true)
        allow(YAML).to receive(:load_file).with(config_path).and_return(user_config)
      end

      it 'loads the config file as a hash' do
        expected_config =
          {
            'api_key' => 'test_api_key',
            'bots' => { 'bot1' => { 'name' => 'Bot1', 'prompt' => 'This is a prompt for Bot1.' } }
          }
        expect(Sawara::UserConfig.read).to eq(expected_config)
      end
    end
  end

  describe '.save' do
    let(:store) { double('store') }

    before do
      allow(YAML::Store).to receive(:new).with(config_path).and_return(store)
      allow(store).to receive(:transaction).and_yield
    end

    it 'saves the key and value to the config file' do
      expect(store).to receive(:[]=).with('api_key', 'test_api_key')
      Sawara::UserConfig.save('api_key', 'test_api_key')
    end
  end
end

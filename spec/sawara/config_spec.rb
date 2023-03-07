# frozen_string_literal: true

RSpec.describe Sawara::Config do
  describe '#api_key' do
    it 'returns the API key from the config file' do
      allow(YAML).to receive(:load_file).and_return({ 'api_key' => 'my-api-key' })

      config = Sawara::Config.new
      expect(config.api_key).to eq('my-api-key')
    end
  end
end

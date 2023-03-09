# frozen_string_literal: true

RSpec.describe Sawara::ApiKey do
  let(:api_key) { Sawara::ApiKey.new }

  describe '#read' do
    it 'returns the API key' do
      allow(Sawara::UserConfig).to receive(:read).and_return({ 'api_key' => 'test_api_key' })
      expect(api_key.read).to eq('test_api_key')
    end
  end

  describe '#update' do
    context 'when a new api_key is entered' do
      before do
        allow(api_key).to receive(:await_api_key).and_return('new_test_api_key')
      end

      it 'updates the api_key in the configuration' do
        expect(Sawara::UserConfig).to receive(:save).with('api_key', 'new_test_api_key')
        api_key.update
      end
    end

    context 'when the entered api_key is nil' do
      before do
        allow(api_key).to receive(:await_api_key).and_return(nil)
        allow(Sawara::UserConfig).to receive(:save)
      end

      it 'does not update the api_key in the configuration' do
        expect(Sawara::UserConfig).not_to have_received(:save)
        api_key.update
      end
    end
  end
end

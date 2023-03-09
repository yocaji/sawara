# frozen_string_literal: true

RSpec.describe Sawara::ChatClient do
  describe '#fetch' do
    context 'with valid parameters' do
      let(:parameters) { { model: 'gpt-3.5-turbo', messages: ['Hello'] } }
      let(:response) { { 'choices' => [{ 'message' => { 'content' => 'Hi there!' } }] } }
      let(:client) { Sawara::ChatClient.new('test_api_key') }

      it 'returns the expected response' do
        allow(client.instance_variable_get(:@openai_client)).to receive(:chat).with(parameters:).and_return(response)

        expect(client.fetch(['Hello'])).to eq('Hi there!')
      end
    end
  end
end

# frozen_string_literal: true

RSpec.describe Sawara::ChatClient do
  describe '#fetch' do
    before do
      openai_client = instance_double('OpenAI::Client')
      allow(OpenAI::Client).to receive(:new).and_return(openai_client)
      response = { 'choices' => [{ 'message' => { 'content' => 'test response' } }] }
      allow(openai_client).to receive(:chat).and_return(response)
    end

    it 'returns the content from OpenAI API' do
      user_config = double('user_config', api_key: 'my-api-key')
      chat_client = Sawara::ChatClient.new(user_config)
      messages = ['hello']
      expect(chat_client.fetch(messages)).to eq('test response')
    end
  end
end

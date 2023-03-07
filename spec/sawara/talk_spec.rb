# frozen_string_literal: true

require 'readline'

RSpec.describe Sawara::Talk do
  before do
    @talk = Sawara::Talk.new
  end

  describe '#start' do
    before do
      allow(@talk).to receive(:await_user_content).and_return('')
    end

    it 'prints gem name' do
      expect { @talk.start(nil) }.to output(/S a w a r a 🐟/).to_stdout
    end

    it 'breaks out of the loop when user input is empty' do
      expect { @talk.start(nil) }.to output.to_stdout
    end
  end

  describe '#await_user_content' do
    it 'accepts user input and adds it to @messages' do
      allow(Readline).to receive(:readline).and_return("hello\n", nil)
      @talk.send(:await_user_content)

      last_message = @talk.instance_variable_get(:@messages).last
      expect(last_message).to eq({ role: 'user', content: 'hello' })
    end
  end

  describe '#await_assistant_content' do
    before do
      @client = double('chat_client')
      allow(@client).to receive(:fetch).and_return('response')
    end

    it 'receives response from client, adds it to @messages, and prints it' do
      expect { @talk.send(:await_assistant_content, @client) }.to output(/response/).to_stdout
      last_message = @talk.instance_variable_get(:@messages).last
      expect(last_message).to eq({ role: 'assistant', content: 'response' })
    end
  end
end

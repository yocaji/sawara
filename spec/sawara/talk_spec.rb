# frozen_string_literal: true

require 'readline'

RSpec.describe Sawara::Talk do
  describe '#start' do
    let(:talk) { Sawara::Talk.new }
    let(:client) { double('chat_client') }

    context 'when user input is empty' do
      before do
        allow(Readline).to receive(:readline).and_return(nil)
        allow(talk).to receive(:await_assistant_content)
      end

      it 'prints gem name' do
        expect { talk.start(client) }.to output(/S a w a r a 🐟/).to_stdout
      end

      it 'exits the loop' do
        talk.start(client)
        expect(talk).not_to have_received(:await_assistant_content)
      end
    end

    context 'when user inputs a message' do
      before do
        allow(Readline).to receive(:readline).and_return('Hello', 'World', nil)
      end

      it 'gets a response from the Assistant' do
        expect(client).to receive(:fetch).with([{ role: 'user', content: "Hello\nWorld\n" }]).and_return('Hi there!')
        expect { talk.start(client) }.to output(/Hi there!/).to_stdout
      end
    end
  end
end

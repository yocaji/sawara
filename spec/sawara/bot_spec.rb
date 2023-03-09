# frozen_string_literal: true

RSpec.describe Sawara::Bot do
  let(:profiles) do
    {
      'bot1' => { 'name' => 'Bot1', 'prompt' => 'Prompt for Bot1.' },
      'bot2' => { 'name' => 'Bot2', 'prompt' => 'Prompt for Bot2.' }
    }
  end

  describe '#list' do
    context 'when there are no bots' do
      it 'displays a message indicating that no bots are registered' do
        allow(Sawara::UserConfig).to receive(:read).and_return({ 'bots' => {} })
        message = <<~TEXT

          No bots are registered🫥
          To register a bot, use `sawara add [NAME]`.
        TEXT
        expect { Sawara::Bot.new.list }.to output(message).to_stdout
      end
    end

    context 'when there are bots' do
      it 'displays a list of registered bots' do
        allow(Sawara::UserConfig).to receive(:read).and_return({ 'bots' => profiles })
        message = <<~TEXT

          Bot1(bot1):
            "Prompt for Bot1."
          Bot2(bot2):
            "Prompt for Bot2."
        TEXT
        expect { Sawara::Bot.new.list }.to output(message).to_stdout
      end
    end
  end

  describe '#create' do
    let(:bot) { Sawara::Bot.new }

    before do
      allow(bot).to receive(:id_is_valid?).and_return(true)
      allow(bot).to receive(:await_name).and_return('NewBot')
      allow(bot).to receive(:await_prompt).and_return('Prompt for NewBot.')
      allow(Sawara::UserConfig).to receive(:save)
    end

    context 'when the bot id is valid' do
      it 'creates a new bot' do
        message = <<~TEXT

          newbot's default prompt registration was successful🎉
          To begin a conversation with newbot, use `sawara -c newbot`.
        TEXT
        expect { bot.create('newbot') }.to output(message).to_stdout
      end
    end

    context 'when the bot id is invalid' do
      it 'does not create a new bot' do
        allow(bot).to receive(:id_is_valid?).and_return(false)

        expect { bot.create('invalid_id') }.to output('').to_stdout
        expect(bot).to_not have_received(:await_name)
        expect(bot).to_not have_received(:await_prompt)
        expect(Sawara::UserConfig).to_not have_received(:save)
      end
    end
  end

  describe '#find' do
    before do
      allow(Sawara::UserConfig).to receive(:read).and_return({ 'bots' => profiles })
    end

    context 'when the bot exists' do
      it 'returns and prints the bot profile' do
        message = <<~TEXT

          Loaded the bot "Bot2". The prompt is as follows:
          Prompt for Bot2.
        TEXT
        expect do
          expect(Sawara::Bot.new.find('bot2')).to eq({ 'name' => 'Bot2', 'prompt' => 'Prompt for Bot2.' })
        end.to output(message).to_stdout
      end
    end

    context 'when the bot does not exist' do
      it 'prints an error message' do
        message = <<~TEXT
          The bot has id "unknown_id" does not exist in the registered bots.
        TEXT
        expect { Sawara::Bot.new.find('unknown_id') }.to output(message).to_stdout
      end
    end
  end

  describe '#delete' do
    let(:bot) { Sawara::Bot.new }

    before do
      allow(Sawara::UserConfig).to receive(:read).and_return({ 'bots' => profiles })
      allow(Sawara::UserConfig).to receive(:save)
      allow(bot).to receive(:exists?).with('bot1').and_return(true)
      allow(bot).to receive(:await_confirm).and_return(true)
    end

    context 'when given id exists' do
      it 'deletes the bot and updates user config' do
        message = <<~TEXT
          ⚠️Are you sure you want to delete bot1? (y/n)

          "bot1" has been deleted.
        TEXT
        profiles_just_bot2 = { 'bot2' => { 'name' => 'Bot2', 'prompt' => 'Prompt for Bot2.' } }
        expect { bot.delete('bot1') }.to output(message).to_stdout
        expect(Sawara::UserConfig).to have_received(:save).with('bots', profiles_just_bot2)
        expect(profiles).not_to have_key('bot1')
      end

      it 'does not delete the bot if confirmation is not given' do
        allow(bot).to receive(:await_confirm).and_return(false)
        message = <<~TEXT
          ⚠️Are you sure you want to delete bot1? (y/n)
        TEXT
        expect { bot.delete('bot1') }.to output(message).to_stdout
        expect(Sawara::UserConfig).to_not have_received(:save)
        expect(profiles).to have_key('bot1')
      end
    end

    context 'when given id does not exist' do
      it 'does not delete the bot and displays an error message' do
        allow(bot).to receive(:exists?).with('unknown_id').and_return(false)
        message = <<~TEXT
          The bot has id "unknown_id" does not exist in the registered bots.
        TEXT
        expect { bot.delete('unknown_id') }.to output(message).to_stdout
        expect(bot).to_not have_received(:await_confirm)
        expect(Sawara::UserConfig).to_not have_received(:save)
      end
    end
  end
end

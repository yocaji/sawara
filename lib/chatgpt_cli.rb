# frozen_string_literal: true

require 'byebug'
require 'cli/ui'
require 'openai'
require 'yaml'
require 'yaml/store'

class ChatgptCli
  CONFIG_PATH = "#{Dir.home}/.chatgpt-cli".freeze

  def self.start
    new.start
  end

  def start
    if File.exist? CONFIG_PATH
      load_config
    else
      File.new CONFIG_PATH
      update_config
    end

    puts 'Hint: Type "quit" to end this conversation.'
    messages = []
    loop do
      question = CLI::UI.ask('Enter your message.')

      break if question.downcase == 'quit'

      puts 'Waiting...'
      messages << { role: 'user', content: question }
      talk messages
    end
  end

  private

  def load_config
    config = YAML.load_file(CONFIG_PATH)
    @api_key = config['api_key']
  end

  def update_config
    api_key = CLI::UI.ask('Enter your OpenAI API Key.')
    store = YAML::Store.new CONFIG_PATH
    store.transaction do
      store['api_key'] = api_key
    end
  end

  def client
    OpenAI.configure do |config|
      config.access_token = @api_key
    end
    OpenAI::Client.new
  end

  def talk(messages)
    response = client.chat(
      parameters: { model: 'gpt-3.5-turbo', messages: }
    )
    puts response
    answer = response.dig('choices', 0, 'message', 'content')
    puts answer
    messages << { role: 'assistant', content: answer }
  end
end

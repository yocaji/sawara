# frozen_string_literal: true

require 'byebug'
require 'cli/ui'
require 'openai'
require_relative 'client'
require_relative 'config'

module ChatgptCli

  class Talk
    def start
      config = Config.new
      client = Client.new.launch(config)

      puts 'Hint: Type "quit" to end this conversation.'
      messages = []
      loop do
        question = CLI::UI.ask('Enter your message.')

        break if question.downcase == 'quit'

        puts 'Waiting...'
        messages << { role: 'user', content: question }
        request(client, messages)
      end
    end

    private

    def request(client, messages)
      response = client.chat(
        parameters: { model: 'gpt-3.5-turbo', messages: }
      )
      answer = response.dig('choices', 0, 'message', 'content')
      puts answer
      messages << { role: 'assistant', content: answer }
    end
  end
end

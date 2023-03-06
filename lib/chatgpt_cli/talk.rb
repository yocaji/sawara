# frozen_string_literal: true

require 'byebug'
require 'openai'
require_relative 'client'
require_relative 'config'

module ChatgptCli

  class Talk
    def start
      config = Config.new
      client = Client.new.launch(config)

      puts 'Hint: To send your message, press "Ctrl + d".'
      puts 'Hint: To exit this conversation, press "Ctrl + d" without entering any input.'
      messages = []
      loop do
        content = []
        loop do
          line = gets
          break if line.nil?

          content << line
        end

        question = content.join
        pp question

        break if question.empty?

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

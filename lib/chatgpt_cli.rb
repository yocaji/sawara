# frozen_string_literal: true

require 'byebug'
require 'cli/ui'
require 'dotenv/load'
require 'openai'

class ChatgptCli
  def initialize
    OpenAI.configure do |config|
      config.access_token = ENV['OPENAI_ACCESS_TOKEN']
    end
    @client = OpenAI::Client.new
  end

  def self.start
    new.start
  end

  def start
    puts 'Hint: Type "quit" to end this conversation.'
    messages = []
    loop do
      question = CLI::UI.ask('Enter your message.', default: 'Hello!')
      break if question.downcase == 'quit'

      puts 'Waiting...'
      messages << { role: 'user', content: question }
      puts messages
      response = @client.chat(
        parameters: {
          model: 'gpt-3.5-turbo',
          messages: messages
        }
      )
      answer = response.dig('choices', 0, 'message', 'content')
      puts answer
      messages << { role: 'assistant', content: answer }
    end
  end

  class Error < StandardError; end
end

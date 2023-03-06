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
    loop do
      question = CLI::UI.ask('Enter your message.', default: 'Hello!')
      break if question.downcase == 'exit'

      puts 'Waiting...'
      response = @client.chat(
        parameters: {
          model: 'gpt-3.5-turbo',
          messages: [
            { role: 'user', content: question }
          ]
        }
      )
      pp response
      puts response.dig('choices', 0, 'message', 'content')
    end
  end

  class Error < StandardError; end
end

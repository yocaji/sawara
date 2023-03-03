# frozen_string_literal: true

require 'byebug'
require 'dotenv/load'
require 'openai'

class ChatgptCli
  class Error < StandardError; end

  def self.hello
    OpenAI.configure do |config|
      config.access_token = ENV['OPENAI_ACCESS_TOKEN']
    end

    client = OpenAI::Client.new

    response = client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages: [
          { role: 'user', content: 'こんにちは！' }
        ]
      }
    )
    pp response
    puts response.dig('choices', 0, 'message', 'content')
  end
end

# frozen_string_literal: true

require 'openai'

module Sawara
  class ChatClient
    def initialize(api_key)
      OpenAI.configure do |config|
        config.access_token = api_key
      end
      @openai_client = OpenAI::Client.new
    end

    def fetch(messages)
      response = @openai_client.chat(
        parameters: { model: 'gpt-3.5-turbo', messages: }
      )
      response.dig('choices', 0, 'message', 'content').sub(/^\n*/, '')
    end
  end
end

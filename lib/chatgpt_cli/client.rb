# frozen_string_literal: true

require 'openai'

module ChatgptCli

  class Client
    def launch(user_config)
      api_key = user_config.api_key
      OpenAI.configure do |config|
        config.access_token = api_key
      end
      OpenAI::Client.new
    end
  end
end

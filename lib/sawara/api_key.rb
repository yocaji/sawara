# frozen_string_literal: true

require_relative 'user_config'

module Sawara
  class ApiKey
    def load
      api_key = UserConfig.load('api_key')
      await_api_key if api_key.empty?
    end

    def update
      api_key = await_api_key
      UserConfig.store('api_key', api_key)
    end

    private

    def await_api_key
      puts '🔑Enter your OpenAI API Key.'
      $stdin.gets
    end
  end
end

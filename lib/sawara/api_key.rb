# frozen_string_literal: true

require_relative 'user_config'

module Sawara
  class ApiKey
    def read
      UserConfig.new.read['api_key']
    end

    def update
      api_key = await_api_key
      UserConfig.new.save('api_key', api_key)
    end

    private

    def await_api_key
      puts '🔑Enter your OpenAI API Key.'
      $stdin.gets.chomp
    end
  end
end

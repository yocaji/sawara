# frozen_string_literal: true

module Sawara
  class ApiKey
    def read
      UserConfig.read['api_key']
    end

    def update
      api_key = await_api_key
      return if api_key.nil?

      UserConfig.save('api_key', api_key)
    end

    private

    def await_api_key
      puts 'Please enter your OpenAI API Key🔑'
      input = $stdin.gets
      return if input.nil?

      api_key = input.chomp
      api_key.empty? ? await_api_key : api_key
    end
  end
end

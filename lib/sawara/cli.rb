# frozen_string_literal: true

require 'thor'

module Sawara
  class CLI < Thor
    desc 'hi', 'Start a conversation with a bot without any prompts'
    def hi
      api_key = Sawara::ApiKey.new.load
      client = Sawara::ChatClient.new(api_key)
      Sawara::Talk.new.start(client)
    end

    desc 'setkey', 'Register or update an API key for OpenAI API'
    def setkey
      config = Sawara::ApiKey.new
      config.set_api_key
    end

    map %w[-v --version] => :version
    desc 'version | -v', 'Print version'
    def version
      puts Sawara::VERSION
    end
  end
end

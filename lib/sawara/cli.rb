# frozen_string_literal: true

require 'thor'

module Sawara
  class CLI < Thor
    desc 'hi', 'Start a conversation with a bot without any prompts'
    def hi
      api_key = Sawara::ApiKey.new
      api_key.update if api_key.read.empty?
      client = Sawara::ChatClient.new(api_key.read)
      Sawara::Talk.new.start(client)
    end

    desc 'setkey', 'Register or update an API key for OpenAI API'
    def setkey
      config = Sawara::ApiKey.new
      config.set_api_key
    end

    desc 'add', 'Register a prompt of bot'
    def add
      Sawara::Persona.create
    end

    map '-p' => :persona
    desc 'persona', '後で書く'
    def persona(name)
      Persona.load(name)
    end

    map %w[-v --version] => :version
    desc 'version | -v', 'Print version'
    def version
      puts Sawara::VERSION
    end
  end
end

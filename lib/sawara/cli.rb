# frozen_string_literal: true

require 'thor'

module Sawara
  class CLI < Thor
    desc 'hi', 'Start a conversation with a bot without any prompts.'
    def hi
      client = launch_client
      Sawara::Talk.new.start(client)
    end

    desc 'bot [NAME], -b [NAME]', 'Starts a conversation with the bot named [NAME].'
    map '-b' => :bot
    def bot(name)
      client = launch_client
      prompt = Bot.new.find(name)
      talk = Sawara::Talk.new(prompt)
      talk.start(client)
    end

    desc 'setkey', 'Register or update an API key for OpenAI API.'
    def setkey
      Sawara::ApiKey.new.set_api_key
    end

    desc 'add [NAME]', 'Register a new bot with name and prompt.'
    def add(name)
      Sawara::Bot.new.create(name)
    end

    desc 'delete [NAME]', 'Deletes the bot named [NAME].'
    def delete(name)
      Sawara::Bot.new.delete(name)
    end

    desc 'list, -l', 'List all bots with their names and prompts.'
    map '-l' => :list
    def list
      Bot.new.list
    end

    desc 'version, -v', 'Print version.'
    map %w[-v --version] => :version
    def version
      puts Sawara::VERSION
    end

    private

    def launch_client
      api_key = Sawara::ApiKey.new
      api_key.update if api_key.read.empty?
      Sawara::ChatClient.new(api_key.read)
    end
  end
end

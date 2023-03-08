# frozen_string_literal: true

require 'thor'

module Sawara
  class CLI < Thor
    desc 'hi', 'Start a conversation with a bot without any prompts.'
    def hi
      client = launch_client
      Talk.new.start(client)
    end

    desc 'bot [ID], -b [ID]', 'Starts a conversation with the bot named [ID].'
    map '-b' => :bot
    def bot(id)
      prompt = Bot.new.find(id)
      return if prompt.nil?

      client = launch_client
      talk = Talk.new(prompt)
      talk.start(client)
    end

    desc 'setkey', 'Register or update an API key for OpenAI API.'
    def setkey
      ApiKey.new.update
    end

    desc 'add [ID]', 'Register a new bot with name and prompt.'
    def add(id)
      Bot.new.create(id)
    end

    desc 'delete [ID]', 'Deletes the bot named [ID].'
    def delete(id)
      Bot.new.delete(id)
    end

    desc 'list, -l', 'List all bots with their names and prompts.'
    map '-l' => :list
    def list
      Bot.new.list
    end

    desc 'version, -v', 'Print version.'
    map %w[-v --version] => :version
    def version
      puts VERSION
    end

    private

    def launch_client
      api_key = ApiKey.new
      api_key.update if api_key.read.empty?
      ChatClient.new(api_key.read)
    end
  end
end

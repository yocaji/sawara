# frozen_string_literal: true

require 'thor'

module Sawara
  class CLI < Thor
    desc 'call [ID], -c [ID]', 'Start a conversation (If [ID] is there, preload the prompt of the bot specified by [ID])'
    map '-c' => :call
    def call(id = nil)
      client = launch_client
      if id.nil?
        Talk.new.start(client)
      else
        profile = Bot.new.find(id)
        return if profile.nil?

        talk = Talk.new(profile)
        talk.start(client)
      end
    end

    desc 'setkey', 'Register or update an API key for OpenAI API'
    def setkey
      ApiKey.new.update
    end

    desc 'add [ID]', 'Register a new bot with name and prompt'
    def add(id)
      Bot.new.create(id)
    end

    desc 'delete [ID]', 'Delete the bot specified by [ID]'
    def delete(id)
      Bot.new.delete(id)
    end

    desc 'list, -l', 'List all bots with their names and prompts'
    map '-l' => :list
    def list
      Bot.new.list
    end

    desc 'version, -v', 'Print version'
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

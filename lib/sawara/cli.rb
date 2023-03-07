# frozen_string_literal: true

require 'thor'

module Sawara
  class CLI < Thor
    desc 'hi', 'Start a conversation with a bot without any prompts'

    def hi
      config = Sawara::Config.new
      client = Sawara::ChatClient.new(config)
      Sawara::Talk.new.start(client)
    end

    map %w[-v --version] => :version
    desc 'version | -v', 'Print version'
    def version
      puts Sawara::VERSION
    end
  end
end

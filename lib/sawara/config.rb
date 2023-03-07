# frozen_string_literal: true

require 'yaml'
require 'yaml/store'

module Sawara
  class Config
    CONFIG_PATH = "#{Dir.home}/.sawara".freeze

    def initialize
      unless File.exist?(CONFIG_PATH)
        File.new(CONFIG_PATH, 'w')
        update_config
      end
      @config = load_config
    end

    def api_key
      @config['api_key']
    end

    private

    def load_config
      YAML.load_file(CONFIG_PATH)
    end

    def update_config
      puts 'Enter your OpenAI API Key.'
      api_key = $stdin.gets
      store = YAML::Store.new(CONFIG_PATH)
      store.transaction do
        store['api_key'] = api_key
      end
    end
  end
end

# frozen_string_literal: true

require 'yaml'
require 'yaml/store'

module Sawara
  class UserConfig
    CONFIG_PATH = "#{Dir.home}/.sawara.yml".freeze

    def initialize
      set_api_key unless File.exist?(CONFIG_PATH)
      @user_config = load_user_config
    end

    def api_key
      @user_config['api_key']
    end

    def set_api_key
      File.new(CONFIG_PATH, 'w') unless File.exist?(CONFIG_PATH)
      api_key = await_api_key
      store('api_key', api_key)
    end

    private

    def load_user_config
      YAML.load_file(CONFIG_PATH)
    end

    def await_api_key
      puts '🔑Enter your OpenAI API Key.'
      $stdin.gets
    end

    def store(key, value)
      store = YAML::Store.new(CONFIG_PATH)
      store.transaction do
        store[key] = value
      end
    end
  end
end

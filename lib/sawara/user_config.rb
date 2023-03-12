# frozen_string_literal: true

require 'yaml'
require 'yaml/store'

module Sawara
  class UserConfig
    CONFIG_PATH = "#{Dir.home}/.sawara.yml".freeze

    def initialize
      return if File.exist?(CONFIG_PATH)

      File.new(CONFIG_PATH, 'w')
      save('api_key', '')
    end

    def read
      YAML.load_file(CONFIG_PATH)
    end

    def save(key, value)
      store = YAML::Store.new(CONFIG_PATH)
      store.transaction do
        store[key] = value
      end
    end
  end
end

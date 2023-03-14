# frozen_string_literal: true

require 'yaml'
require 'yaml/store'

module Sawara
  class UserConfig
    CONFIG_PATH = "#{Dir.home}/.sawara.yml".freeze

    class << self
      def read
        create_config_file unless File.exist?(CONFIG_PATH)
        YAML.load_file(CONFIG_PATH)
      end

      def save(key, value)
        store = YAML::Store.new(CONFIG_PATH)
        store.transaction do
          store[key] = value
        end
      end

      private

      def create_config_file
        File.new(CONFIG_PATH, 'w')
        save('api_key', '')
        save('bots', {})
      end
    end
  end
end

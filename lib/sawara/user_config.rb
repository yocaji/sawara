# frozen_string_literal: true

require 'byebug'
require 'yaml'
require 'yaml/store'

module Sawara
  class UserConfig
    CONFIG_PATH = "#{Dir.home}/.sawara.yml".freeze

    # def initialize
    #   set_api_key unless File.exist?(CONFIG_PATH)
    #   @user_config = load_user_config
    # end

    def self.load(key)
      # ファイルが無い時の処理はこれで良い？
      File.new(CONFIG_PATH, 'w') unless File.exist?(CONFIG_PATH)
      user_config = YAML.load_file(CONFIG_PATH)
      user_config ? user_config[key] : ''
    end

    def self.store(key, value)
      File.new(CONFIG_PATH, 'w') unless File.exist?(CONFIG_PATH)
      store = YAML::Store.new(CONFIG_PATH)
      store.transaction do
        store[key] = value
      end
    end
  end
end

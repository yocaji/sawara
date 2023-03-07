# frozen_string_literal: true

require_relative 'sawara/api_key'
require_relative 'sawara/chat_client'
require_relative 'sawara/cli'
require_relative 'sawara/user_config'
require_relative 'sawara/talk'
require_relative 'sawara/version'

module Sawara
  class Error < StandardError; end
end

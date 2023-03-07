# frozen_string_literal: true

require_relative 'chatgpt_cli/chat_client'
require_relative 'chatgpt_cli/config'
require_relative 'chatgpt_cli/talk'
require_relative 'chatgpt_cli/version'

module ChatgptCli
  class Error < StandardError; end
end

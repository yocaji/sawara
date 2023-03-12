# frozen_string_literal: true

require 'readline'

module Sawara
  class Talk
    def initialize
      @messages = []
    end

    def start(client)
      display_header

      loop do
        user_content = await_user_content
        break if user_content.empty?

        await_assistant_content(client)
      end
    end

    private

    def display_header
      hints = <<~MSG
        Hint 1: To send your message, press "Enter" and "Ctrl + d".
        Hint 2: To exit this conversation, press "Ctrl + d" without any message.
      MSG
      puts
      puts 'S a w a r a 🐟'.center(80)
      puts '*' * 80
      puts hints
      puts '*' * 80
    end

    def await_user_content
      puts
      puts 'You:'

      lines = []
      while (line = Readline.readline)
        lines << line
      end

      content = lines.join.sub(/\n*$/, '')
      @messages << { role: 'user', content: }
      content
    end

    def await_assistant_content(client)
      puts
      puts 'Sawara:'

      content = client.fetch(@messages)
      @messages << { role: 'assistant', content: }
      puts content
    end
  end
end

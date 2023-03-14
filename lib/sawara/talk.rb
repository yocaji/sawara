# frozen_string_literal: true

require 'readline'

module Sawara
  class Talk
    def initialize(profile = nil)
      @messages = []
      if profile.nil?
        @name = 'Sawara'
      else
        @name = profile['name']
        @messages << { role: 'system', content: profile['prompt'] }
      end
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
        lines << ("#{line}\n")
      end

      content = lines.join
      @messages << { role: 'user', content: }
      content
    end

    def await_assistant_content(client)
      puts
      puts "#{@name}:"

      content = client.fetch(@messages)
      @messages << { role: 'assistant', content: }
      puts content
    end
  end
end

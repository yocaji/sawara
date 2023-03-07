# frozen_string_literal: true

require 'byebug'

module ChatgptCli

  class Talk
    def initialize
      @messages = []
    end
    def start(client)
      puts 'Hint: To send your message, press "Enter" and "Ctrl + d".'
      puts 'Hint: To exit this conversation, press "Ctrl + d" without any message.'
      puts ''
      loop do
        user_content = await_user_content
        break if user_content.empty?

        await_assistant_content(client)
      end
    end

    private

    def await_user_content
      print 'You: '
      content = $stdin.readlines.join
      @messages << { role: 'user', content: }
      content
    end

    def await_assistant_content(client)
      print 'Vanilla: '
      content = client.fetch(@messages)
      @messages << { role: 'assistant', content: }
      puts content
    end
  end
end

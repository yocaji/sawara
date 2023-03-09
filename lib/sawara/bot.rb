# frozen_string_literal: true

require 'readline'

module Sawara
  class Bot
    def initialize
      @bots = UserConfig.read['bots']
    end

    def list
      puts
      if @bots.empty?
        puts 'No bots are registered🫥'
        puts 'To register a bot, use `sawara add [NAME]`.'
      else
        @bots.each do |id, profile|
          puts "#{profile['name']}(#{id}):"
          puts "  \"#{profile['prompt']}\""
        end
      end
    end

    def create(id)
      return unless id_is_valid?(id)

      name = await_name
      return if name.nil?

      prompt = await_prompt
      return if prompt.empty?

      @bots[id] = { 'name' => name, 'prompt' => prompt }
      UserConfig.save('bots', @bots)
      puts
      puts "#{id}'s default prompt registration was successful🎉"
      puts "To begin a conversation with #{id}, use `sawara -c #{id}`."
    end

    def find(id)
      if exists?(id)
        profile = @bots[id]
        puts
        puts "Loaded the bot \"#{profile['name']}\". The prompt is as follows:"
        puts profile['prompt']
        profile
      else
        puts "The bot has id \"#{id}\" does not exist in the registered bots."
      end
    end

    def delete(id)
      if exists?(id)
        puts "⚠️Are you sure you want to delete #{id}? (y/n)"
        return unless await_confirm

        @bots.delete(id)
        UserConfig.save('bots', @bots)
        puts
        puts "\"#{id}\" has been deleted."
      else
        puts "The bot has id \"#{id}\" does not exist in the registered bots."
      end
    end

    private

    def await_name
      puts
      puts 'Please enter the name of your bot😉'
      line = Readline.readline
      return if line.nil?

      name = line.chomp
      name.empty? ? await_name : name
    end

    def await_prompt
      puts
      puts 'Please enter the prompt of your bot📜'
      lines = []
      while (line = Readline.readline)
        lines << ("#{line}\n")
      end
      lines.join.gsub(/^\n+|\n+$/, '')
    end

    def await_confirm
      line = Readline.readline
      return if line.nil?

      confirm = line.chomp.downcase
      confirm == 'y'
    end

    def id_is_valid?(id)
      if id.empty?
        puts 'Bot id must have at least one character.'
        false
      elsif exists?(id)
        puts "\"#{id}\" is already registered id."
        false
      else
        true
      end
    end

    def exists?(id)
      @bots.key?(id)
    end
  end
end

# frozen_string_literal: true

require 'readline'

module Sawara
  class Bot
    def initialize
      @bots = UserConfig.new.read['bots']
    end

    def list
      puts
      if @bots.empty?
        puts 'No bots are registered🫥'
        puts 'To register a bot, use `sawara add [NAME]`.'
      else
        @bots.each do |name, prompt|
          puts "#{name}: #{prompt}"
        end
      end
    end

    def create(name)
      return unless name_is_valid?(name)

      prompt = await_prompt
      return if prompt.nil?

      @bots[name] = prompt
      UserConfig.new.save('bots', @bots)
      puts
      puts "#{name}'s default prompt registration was successful🎉"
      puts "To begin a conversation with #{name}, use `sawara -b #{name}`."
    end

    def find(name)
      if @bots[name].nil?
        puts
        puts "\"#{name}\" was not found."
      else
        prompt = @bots[name]
        puts
        puts "Loaded the bot \"#{name}\". The prompt is as follows:"
        puts prompt
        { name:, prompt: }
      end
    end

    def delete(name)
      if exists?(name)
        puts "⚠️Are you sure you want to delete #{name}? (y/n)"
        return unless await_confirm

        @bots.delete(name)
        UserConfig.new.save('bots', @bots)
        puts
        puts "\"#{name}\" has been deleted."
      else
        puts "\"#{name}\" does not exist in the registered bots."
      end
    end

    private

    def await_prompt
      puts
      puts 'Please enter the prompt of your bot📜'
      line = Readline.readline
      return if line.nil?

      prompt = line.chomp
      prompt.empty? ? await_prompt : prompt
    end

    def await_confirm
      line = Readline.readline
      return if line.nil?

      confirm = line.chomp.downcase
      confirm == 'y'
    end

    def name_is_valid?(name)
      if name.empty?
        puts 'Bot name must have at least one character.'
        false
      elsif exists?(name)
        puts "\"#{name}\" is already registered."
        false
      else
        true
      end
    end

    def exists?(name)
      !!@bots[name]
    end
  end
end

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
        @bots.each do |id, profile|
          puts "#{profile[:name]}(#{id}):"
          puts "  \"#{profile[:prompt]}\""
        end
      end
    end

    def create(id)
      return unless id_is_valid?(id)

      name = await_name
      return if name.nil?

      prompt = await_prompt
      return if prompt.empty?

      @bots[id] = { name:, prompt: }
      UserConfig.new.save('bots', @bots)
      puts
      puts "#{id}'s default prompt registration was successful🎉"
      puts "To begin a conversation with #{id}, use `sawara -b #{id}`."
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
      !!@bots[id]
    end
  end
end

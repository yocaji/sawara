# Sawara

![image](https://user-images.githubusercontent.com/33394676/224897066-0429c135-c1b0-49e4-8027-b96ebea93c6d.png)

## Overview

Sawara is a Ruby Gem and command-line interface (CLI) tool that enables you to use ChatGPT in your terminal via OpenAI API.

With Sawara, you can easily create and manage multiple bots with different prompts, and have natural language conversations with them through the CLI.

Of course, you can also start a conversation with a bot without setting a prompt in advance.

## Installation

    $ gem install sawara

## Initial setup

1. Get your API key from [https://platform.openai.com/account/api-keys](https://platform.openai.com/account/api-keys)
2. `$ sawara call` or `$ sawara setkey`
3. Enter your API Key.

## Usage

### Call a bot

    $ sawara call
    $ sawara -c

Use the `sawara call` command to start a conversation.

### Call a registered bot

    $ sawara call <bot_id>
    $ sawara -c <bot_id>

Use the `sawara call` command followed by the ID of the bot to start a conversation with the registered bot.

### Add a bot

    $ sawara add <bot_id>

Use the `sawara add` command followed by the ID of the bot you want to register. You'll be asked to provide a name and a prompt for the bot.

### Delete a bot

    $ sawara delete <bot_id>

Use the `sawara delete` command followed by the ID of the bot you want to remove.

### List all bots

    $ sawara list
    $ sawara -l

Use the `sawara list` command to list all the bots you've registered.

### Set or update your OpenAI API key

    $ sawara setkey

Use the `sawara setkey` command to set or update your OpenAI API key.

### Configuration file

Configuration data will be saved in `~/.sawara.yml`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yocajii/sawara. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/yocajii/sawara/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the sawara project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/sawara/blob/main/CODE_OF_CONDUCT.md).

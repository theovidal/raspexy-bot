# frozen_string_literal: true

require 'telegram/bot'
require 'psych'
require 'time'

require_relative 'lib/command_container'
require_relative 'lib/context'
require_relative 'lib/command'
require_relative 'lib/bot'

# Loading config file
config_file = File.dirname(__FILE__) + '/config.yml'
raise StandardError, 'The configuration file is required' unless File.exist?(config_file)

config = Psych.load(File.read(config_file))

# Dynamically loading commands
commands_dir = 'commands'
Dir["#{commands_dir}/*.rb"].each do |path|
  resp = Regexp.new("([a-z0-9]+)\.rb$").match(path)
  unless resp.nil?
    command_name = resp[1]
    require_relative "#{commands_dir}/#{command_name}"
  end
end

Telegram::Bot::Client.run(config['bot']['token']) do |bot|
  puts 'Telegram bot running.'

  client = Raspexy::Bot.new(bot, config)
  bot.listen do |event|
    unless event.from.id == config['bot']['owner'].to_i
      bot.api.send_message(
        chat_id: event.chat.id,
        text: "🚫 Vous n'avez pas la permission d'intéragir avec le robot."
      )
      next
    end

    case event
    when Telegram::Bot::Types::Message
      next unless event.text[0] == '/'

      client.run_command(event)
    when Telegram::Bot::Types::CallbackQuery
      client.run_command(event, true)
    end
  end
end

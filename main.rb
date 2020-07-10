require 'telegram/bot'
require 'psych'
require 'time'

require_relative 'lib/command_container'
require_relative 'lib/command'
require_relative 'lib/bot'

# Loading config file
config_file = File.dirname(__FILE__) + "/config.yml"
raise StandardError, "The configuration file is required" unless File::exist?(config_file)
config = Psych.load(File.read(config_file))

# Dynamically loading commands
commands = {}
base = 'commands'
Dir["#{base}/*.rb"].each do |path|
  resp = Regexp.new("([a-z0-9]+)\.rb$").match(path)
  if resp != nil
    cmd_name = resp[1]
    require_relative "#{base}/#{cmd_name}"
  end
end

Telegram::Bot::Client.run(config['bot']['token']) do |bot|
  client = Raspexy::Bot.new(bot, config)
  bot.listen do |message|
    next unless message.text[0] == '/'
    client.run_command(message)
  end
end

module Raspexy
  class Bot
    attr_reader :client, :api, :config

    def initialize(client, config)
      @client = client
      @api = client.api
      @config = config
    end

    def run_command(message, callback = false)
      parts = (callback ? message.data : message.text).split
      cmd_name = parts[0].sub('/', '').to_sym
      arguments = parts[1..-1]
  
      command = CommandContainer.commands[cmd_name]
      command.nil? ? @api.send_message(chat_id: message.chat.id, text: '❓ Commande inconnue.') : command.call(self, message, arguments, callback)
    end
  end
end

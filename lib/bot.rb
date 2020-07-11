# frozen_string_literal: true

module Raspexy
  class Bot
    attr_reader :client, :api, :config

    def initialize(client, config)
      @client = client
      @api = client.api
      @config = config
    end

    def run_command(message, callback = false)
      command, arguments = parse_command(message, callback)
      if command.nil?
        @api.send_message(
          chat_id: message.chat.id, text: '❓ Commande inconnue.'
        )
      else
        command.call(self, message, arguments, callback)
      end
    end

    private

    def parse_command(message, callback)
      parts = (callback ? message.data : message.text).split
      name = parts[0].delete_prefix('/').to_sym
      arguments = parts[1..-1]
      command = CommandContainer.commands[name]

      [command, arguments]
    end
  end
end

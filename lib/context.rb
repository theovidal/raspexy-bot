module Raspexy
  class Context
    attr_reader :bot, :message, :chat, :content

    def initialize(bot, message)
      @bot = bot
      @message = message
      @chat = message.chat
      @content = message.text
    end

    def reply(text, markdown = false)
      parse_mode = markdown ? 'Markdown' : nil
      @bot.api.send_message(chat_id: @chat.id, text: text, parse_mode: parse_mode)
    end
  end
end

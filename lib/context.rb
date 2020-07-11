# frozen_string_literal: true

module Raspexy
  class Context
    attr_reader :bot, :message, :chat, :content

    def initialize(bot, message, callback: nil)
      @bot = bot
      @message = message
      @chat = message.chat
      @content = message.text
      @callback_id = callback
    end

    def reply(text, markdown: false, markup: nil)
      parse_mode = markdown ? 'Markdown' : nil
      @bot.api.send_message(
        chat_id: @chat.id,
        text: text,
        parse_mode: parse_mode,
        reply_markup: markup
      )
    end

    def answer_callback
      return if @callback_id.nil?

      begin
        @bot.api.answer_callback_query(callback_query_id: @callback_id)
      rescue Telegram::Bot::Exceptions::ResponseError
        puts "Warning : callback #{@callback_id} already answered"
      end
    end
  end
end

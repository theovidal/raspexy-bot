# frozen_string_literal: true

module Raspexy
  module Commands
    extend CommandContainer

    command :light, 'Contrôler la lumière ambiante' do |context, args|
      case args[0]
      when 'on' then Light.set_state(context, 'high', "💡 Lumière allumée.\n_Et la lumière fut!_")
      when 'off' then Light.set_state(context, 'low', "🌑 Lumière éteinte.\n_Ça va faire tout noir!_")
      when nil
        markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: [
            Telegram::Bot::Types::InlineKeyboardButton.new(text: '💡 Allumer', callback_data: '/light on'),
            Telegram::Bot::Types::InlineKeyboardButton.new(text: '🌑 Éteindre', callback_data: '/light off')
          ]
        )
        context.reply(
          'Que voulez-vous faire avec la lumière ?',
          markdown: false,
          markup: markup
        )
      else
        context.reply('❌ Valeur inconnue.')
      end
    end

    module Light
      def self.set_state(context, state, text)
        `gpio export #{context.bot.config['pins']['light']} #{state}`
        context.reply(text, markdown: true)
        context.answer_callback
      end
    end
  end
end

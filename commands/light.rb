module Raspexy
  module Commands
    extend CommandContainer

    command :light, 'Contrôler la lumière ambiante' do |context, args|
      case args[0]
      when 'on'
        `gpio export #{context.bot.config['pins']['light']} high`
        context.reply("💡 Lumière allumée.\n_Et la lumière fut!_", markdown: true)
        context.answer_callback
      when 'off'
        `gpio export #{context.bot.config['pins']['light']} low`
        context.reply("🌑 Lumière éteinte.\n_Ça va faire tout noir!_", markdown: true)
        context.answer_callback
      when nil
        markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: [
            Telegram::Bot::Types::InlineKeyboardButton.new(text: '💡 Allumer', callback_data: '/light on'),
            Telegram::Bot::Types::InlineKeyboardButton.new(text: '🌑 Éteindre', callback_data: '/light off')
          ]
        )
        context.reply('Que voulez-vous faire avec la lumière ?', markdown: false, markup: markup)

      else
        context.reply('❌ Valeur inconnue.')
      end
    end
  end
end

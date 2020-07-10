module Raspexy
  module Commands
    extend CommandContainer

    command :light, 'Contrôler la lumière ambiante' do |bot, message, args|
      case args[0]
      when 'on'
        `gpio export #{bot.config['pins']['light']} high`
        bot.api.send_message(chat_id: message.chat.id, parse_mode: 'Markdown', text: "💡 Lumière allumée.\n_Et la lumière fut!_")
      when 'off'
        `gpio export #{bot.config['pins']['light']} low`
        bot.api.send_message(chat_id: message.chat.id, parse_mode: 'Markdown', text: "🌑 Lumière éteinte.\n_Ça va faire tout noir!_")
      else
        bot.api.send_message(chat_id: message.chat.id, text: '❌ Valeur inconnue.')
      end
    end
  end
end

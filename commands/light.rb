module Raspexy
  module Commands
    extend CommandContainer

    command :light, 'Contrôler la lumière ambiante' do |context, args|
      case args[0]
      when 'on'
        `gpio export #{context.bot.config['pins']['light']} high`
        context.reply("💡 Lumière allumée.\n_Et la lumière fut!_", markdown: true)
      when 'off'
        `gpio export #{context.bot.config['pins']['light']} low`
        context.reply("🌑 Lumière éteinte.\n_Ça va faire tout noir!_", markdown: true)
      else
        context.reply('❌ Valeur inconnue.')
      end
    end
  end
end

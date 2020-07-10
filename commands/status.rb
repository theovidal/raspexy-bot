module Raspexy
  module Commands
    extend CommandContainer

    command :status, 'Obtenir le statut du Raspberry Pi' do |bot, message, args|
      user = (`whoami`).strip
      uptime = (`uptime`).split(' ')[2].sub(/:/, 'h')[0...-1]
      now = Time.now.strftime("le %d/%m/%Y à %Hh%M")

      temperature = %x{vcgencmd measure_temp}.lines.first.sub(/temp=/, '').sub(/'C\n/, '°C').sub(/\./, ',')
      cpu = %x{top -n1}.lines.find{ |line| /Cpu\(s\):/.match(line) }.split[1]
      memory = %x{top -n1}.lines.find{ |line| /MiB Mem :/.match(line) }.split
      mem_usage = (memory[5].to_f / memory[3].to_f) * 100

      sd = %x{df -h /}.lines.to_a[1].split[1,4]
      usb = %x{df -h /dev/sda1}.lines.to_a[1].split[1,4]

      bot.api.send_message(chat_id: message.chat.id, parse_mode: 'Markdown', text:
        "*Informations générales*\n" \
        "👤 Utilisateur : #{user}\n\n" \
        "*Statut #{now}*\n" \
        "🕑 Durée de fonctionnement : #{uptime}min\n" \
        "🌡 Température : #{temperature}\n" \
        "🎛 Utilisation du processeur : #{cpu}%\n" \
        "📼 Utilisation de la mémoire RAM : #{mem_usage.floor(2)}%\n" \
        "💾 Utilisation du stockage :\n" \
        "  • Carte SD : #{sd[3]} (#{sd[1]}o utilisés sur #{sd[0]}o)\n" \
        "  • Clé USB : #{usb[3]} (#{usb[1]}o utilisés sur #{usb[0]}o)"
      )
    end
  end
end

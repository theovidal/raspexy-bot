require 'telegram/bot'
require 'psych'

config_file = File.dirname(__FILE__) + "/config.yml"
raise StandardError, "The configuration file is required" unless File::exist?(config_file)
config = Psych.load(File.read(config_file))

Telegram::Bot::Client.run(config['bot']['token']) do |bot|
  bot.listen do |message|
    case message.text
    when '/light on'
      `gpio export #{config['pins']['light']} high`
      bot.api.send_message(chat_id: message.chat.id, text: "Et la lumière fut.")
    when '/light off'
      `gpio export #{config['pins']['light']} low`
      bot.api.send_message(chat_id: message.chat.id, text: "Ça va faire tout noir!")
    when '/status'
      temp = %x{vcgencmd measure_temp}.lines.first.sub(/temp=/, '').sub(/'C\n/, '°C').sub(/\./, ',')
      cpu = %x{top -n1}.lines.find{ |line| /Cpu\(s\):/.match(line) }.split[1]
      sd = %x{df -h /}.lines.to_a[1].split[1,4]
      usb = %x{df -h /dev/sda1}.lines.to_a[1].split[1,4]
      bot.api.send_message(chat_id: message.chat.id, parse_mode: 'Markdown', text: "*Statut du Raspberry Pi*\n\n" \
             "🌡 Température : #{temp}\n" \
             "🎛 Utilisation du CPU : #{cpu}%\n" \
             "💾 Utilisation du stockage :\n" \
             "• Carte SD : #{sd[3]} (#{sd[1]}o utilisés sur #{sd[2]}o)\n" \
             "• Clé USB : #{usb[3]} (#{usb[1]}o utilisés sur #{usb[2]}o)"
                          )
    end
  end
end


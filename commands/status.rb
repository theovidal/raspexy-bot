# frozen_string_literal: true

module Raspexy
  module Commands
    extend CommandContainer

    command :status, 'Obtenir le statut du Raspberry Pi' do |context, _|
      user = `whoami`.strip
      now = Time.now.strftime('le %d/%m/%Y à %Hh%M')
      uptime = `uptime`.split(' ')[2].sub(/:/, 'h')[0...-1]
      uptime << 'min'

      cpu_temperature = Status.temperature
      cpu_usage, memory_usage = Status.memory_usage
      sd, usb = Status.storage

      message = "*Informations générales*\n" \
        "👤 Utilisateur : #{user}\n\n" \
        "*Statut #{now}*\n" \
        "🕑 Durée de fonctionnement : #{uptime}\n" \
        "🎛 Processeur :\n" \
        "  • Température : #{cpu_temperature}\n" \
        "  • Utilisation : #{cpu_usage}%\n" \
        "📼 Utilisation de la mémoire RAM : #{memory_usage}%\n" \
        "💾 Utilisation du stockage :\n" \
        "  • Carte SD : #{sd[3]} (#{sd[1]}o utilisés sur #{sd[0]}o)\n" \
        "  • Clé USB : #{usb[3]} (#{usb[1]}o utilisés sur #{usb[0]}o)"

      context.reply(message, markdown: true)
    end

    module Status
      def self.storage
        drives = [`df -h /`, `df -h /dev/sda1`]
        drives.map { |drive| drive.lines.to_a[1].split[1, 4] }
      end

      def self.memory_usage
        top = `top -n1`.lines
        cpu = find_line(top, /Cpu\(s\):/)[1]
        memory = find_line(top, /MiB Mem :/)
        memory_usage = (memory[5].to_f / memory[3].to_f) * 100

        [cpu, memory_usage.floor(2)]
      end

      def self.find_line(data, regex)
        data.find { |line| regex.match(line) }.split
      end

      def self.temperature
        `vcgencmd measure_temp`
          .lines
          .first
          .delete_prefix('temp=')
          .sub(/'C\n/, '°C')
          .sub(/\./, ',')
      end
    end
  end
end

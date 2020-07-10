module Raspexy
  module CommandContainer
    class << self
      attr_accessor :commands
    end

    def command(name, description = '', &block)
      CommandContainer.commands ||= {}

      CommandContainer.commands[name] = Command.new(name, description, &block)
    end
  end
end

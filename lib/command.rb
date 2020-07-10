module Raspexy
  class Command
    attr_reader :name, :description

    def initialize(name, description = '', &block)
      @name = name
      @description = description
      @block = block
    end

    def call(bot, message, arguments)
      @block.call(bot, message, arguments)
    end
  end
end

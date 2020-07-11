# frozen_string_literal: true

module Raspexy
  class Command
    attr_reader :name, :description

    def initialize(name, description = '', &block)
      @name = name
      @description = description
      @block = block
    end

    def call(bot, message, arguments, callback)
      context = callback ? Context.new(bot, message.message, callback: message.id) : Context.new(bot, message)
      @block.call(context, arguments)
    end
  end
end

require 'active_support/inflector'

module Shh
  module Command
    def load_command name, *args
      require "shh/command/#{name}"
      Command.const_get(name.to_s.camelize).new(*args)
    end
  end
end
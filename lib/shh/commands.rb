module Shh
  module Command
    def camelize s
      s.to_s.split('_').map{|word| word.capitalize}.join
    end

    def load_command name, *args
      require "shh/command/#{name}"
      Command.const_get(camelize(name)).new(*args)
    end
  end
end
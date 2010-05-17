require 'shh/command/key_command'

class Shh::Command::ShowKey
  include Shh::Command::KeyCommand

  def help
    "Displays the value associated with the specified key"
  end

  def execute key=nil
    @io.say @entry[key]
  end
end
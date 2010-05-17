require 'shh/command/key_command'

class Shh::Command::RemoveKey
  include Shh::Command::KeyCommand

  def help
    "Removes the specified key from the entry"
  end

  def execute key=nil
    @entry.delete(key)
  end
end
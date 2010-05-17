require 'shh/command/key_command'
require 'splat'

class Shh::Command::EditKey
  include Shh::Command::KeyCommand

  def help
    "Launches an external editor (specified by EDITOR environment variable) to edit the value associated with the specified key"
  end

  def execute key=nil
    new_value = (@entry[key] || '').to_editor
    @entry[key] = new_value if new_value.length > 0
  end
end
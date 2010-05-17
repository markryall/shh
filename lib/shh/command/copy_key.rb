require 'shh/commands'
require 'shh/command/key_command'
require 'splat'

class Shh::Command::CopyKey
  include Shh::Command::KeyCommand

  def help
    "Copies the value associated with the specified key to the clipboard"
  end

  def execute key=nil
    (@entry[key] || '').to_clipboard
  end
end
require 'shh/command/key_command'
require 'splat'

class Shh::Command::LaunchKey
  include Shh::Command::KeyCommand

  def help
    "Launches the value (usually a url) associated with the specified key using default application"
  end

  def execute key=nil
    (@entry[key] || '').to_launcher
  end
end
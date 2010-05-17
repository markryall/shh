require 'shh/command/key_command'

class Shh::Command::SetKey
  include Shh::Command::KeyCommand

  def help
    "Prompts for a new value for the specified key\nKeys with a name including 'pass' (eg. password, passphrase) will not echo input"
  end

  def execute key=nil
    new_value = @io.ask("Enter new value for #{key}", :silent => (key =~ /pass/))
    @entry[key] = new_value if new_value.length > 0
  end
end
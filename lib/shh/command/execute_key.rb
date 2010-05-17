require 'shh/command/key_command'

class Shh::Command::ExecuteKey
  include Shh::Command::KeyCommand

  def help
    "Executes the contents (ruby code) associated with the specified key\nNote that the entire entry is available as a hash called 'entry'"
  end

  def execute key=nil
    begin
      entry = @entry
      eval @entry[key]
    rescue Exception => e
      @io.say e.message
      e.backtrace.each {|t| @io.say " > #{t}" }
    end
  end
end
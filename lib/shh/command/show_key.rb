require 'splat'

class Shh::Command::ShowKey
  def initialize entry, io
    @entry, @io = entry, io
  end

  def completion text
    @entry.keys.grep(/^#{text}/).sort || []
  end

  def execute key=nil
    @io.say @entry[key]
  end
end
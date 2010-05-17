module Shh::Command::KeyCommand
  def initialize entry, io
    @entry, @io = entry, io
  end

  def usage
    "<key name>"
  end

  def completion text
    @entry.keys.grep(/^#{text}/).sort || []
  end
end
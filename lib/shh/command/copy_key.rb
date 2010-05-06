require 'splat'

class Shh::Command::CopyKey
  def initialize entry, io
    @entry, @io = entry, io
  end

  def completion text
    @entry.keys.grep(/^#{text}/).sort || []
  end

  def execute key=nil
    (@entry[key] || '').to_clipboard
  end
end
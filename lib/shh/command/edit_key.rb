require 'splat'

class Shh::Command::EditKey
  def initialize entry, io
    @entry, @io = entry, io
  end

  def completion text
    @entry.keys.grep(/^#{text}/).sort || []
  end

  def execute key=nil
    new_value = (@entry[key] || '').to_editor
    @entry[key] = new_value if new_value.length > 0
  end
end
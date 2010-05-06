class Shh::Command::RemoveKey
  def initialize entry, io
    @entry, @io = entry, io
  end

  def completion text
    @entry.keys.grep(/^#{text}/).sort || []
  end

  def execute key=nil
    @entry.delete(key)
  end
end
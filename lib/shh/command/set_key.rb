class Shh::Command::SetKey
  def initialize entry, io
    @entry, @io = entry, io
  end

  def completion text
    @entry.keys.grep(/^#{text}/).sort || []
  end

  def execute key=nil
    new_value = @io.ask("Enter new value for #{key}", :silent => (key =~ /pass/))
    @entry[key] = new_value if new_value.length > 0
  end
end
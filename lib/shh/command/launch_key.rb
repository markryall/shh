require 'splat'

class Shh::Command::LaunchKey
  def initialize entry, io
    @entry, @io = entry, io
  end

  def completion text
    @entry.keys.grep(/^#{text}/).sort || []
  end

  def execute key=nil
    (@entry[key] || '').to_launcher
  end
end
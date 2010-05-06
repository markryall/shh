class Shh::Command::ExecuteKey
  def initialize entry, io
    @entry, @io = entry, io
  end

  def completion text
    @entry.keys.grep(/^#{text}/).sort || []
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
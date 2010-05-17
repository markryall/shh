class Shh::Command::ListKeys
  attr_reader :usage, :help

  def initialize entry, io
    @entry, @io = entry, io
    @usage = "(<substring>)"
    @help = "Lists all keys for the entry or those including the specified substring"
  end

  def execute text=nil
    @entry.each_key do |key|
      next if text and !(key =~ /#{text}/)
      @io.say key
    end
  end
end
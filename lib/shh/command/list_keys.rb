class Shh::Command::ListKeys
  attr_reader :usage, :help

  def initialize entry, io
    @entry, @io = entry, io
  end

  def execute text=nil
    @entry.each_key do |key|
      @io.say key
    end
  end
end
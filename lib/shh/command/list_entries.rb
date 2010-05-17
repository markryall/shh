class Shh::Command::ListEntries
  attr_reader :usage, :help

  def initialize repository, io
    @repository, @io = repository, io
    @usage = "(<substring>)"
    @help = "Lists all entries"
  end

  def execute text=nil
    @repository.each do |entry|
      next if text and !(entry['name'] ~= /#{text}/)
      @io.say "#{entry['name']} (#{entry['id']})"
    end
  end
end
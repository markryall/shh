class Shh::Command::ListEntries
  attr_reader :usage, :help

  def initialize repository, io
    @repository, @io = repository, io
    @usage = "(<substring>)"
    @help = "Lists all entries or those with a name including the specified substring"
  end

  def execute text=nil
    @repository.sort{|l,r| l['name'] <=> r['name']}.each do |entry|
      next if text and !(entry['name'] =~ /#{text}/)
      @io.say entry['name']
    end
  end
end
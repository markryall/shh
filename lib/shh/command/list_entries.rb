class Shh::Command::ListEntries
  attr_reader :usage, :help

  def initialize repository, io
    @repository, @io = repository, io
    @usage = "(<substring>)"
    @help = "Lists all entries or those with a name including the specified substring"
  end

  def execute text=nil
    @repository.each do |entry|
      unless entry.id == entry['id']
        puts "Encryption failure! Did you enter the correct password?"
        return
      end
    end
    @repository.sort{|l,r| (l['name']) <=> (r['name'])}.each do |entry|
      description = "#{entry['name']} (#{entry.id})"
      next if text and !(description =~ /#{text}/)
      @io.say description
    end
  end
end
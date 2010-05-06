class Shh::Command::ListEntries
  def initialize repository, io
    @repository, @io = repository, io
  end

  def execute text=nil
    @repository.each do |entry|
      @io.say "#{entry['name']} (#{entry['id']})"
    end
  end
end
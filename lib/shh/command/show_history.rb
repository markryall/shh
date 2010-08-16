class Shh::Command::ShowHistory
  attr_reader :usage, :help

  def initialize repository, io
    @repository, @io = repository, io
    @usage = "(<substring>)"
    @help = "Shows history for a given entry"
  end

  def completion text
    @repository.map{|entry| entry['name']}.grep(/^#{text}/).sort || []
  end

  def execute name=nil
    entry = @repository.find { |entry| entry['name'] == name }
    id = entry ? entry.id : nil
    first = true
    @repository.history(id).each do |cs|
      puts '-------' unless first
      puts "#{cs.id} #{cs.time}"
      puts "#{cs.author}"
      puts "#{cs.description}"
      first = false
    end
  end
end
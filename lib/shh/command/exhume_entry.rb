require 'uuidtools'
require 'shh/entry_menu'

class Shh::Command::ExhumeEntry
  attr_reader :usage, :help

  def initialize repository, io
    @repository, @io = repository, io
    @usage = "<entry name>"
    @help = "Enters a subshell for viewing the specifed entry as it was at the specified changeset"
  end

  def completion text
    @repository.map{|entry| entry['name']}.grep(/^#{text}/).sort || []
  end

  def execute text=nil
    if text =~ /^(\w+) (.*)/
      cs = $1
      name = $2
      return unless name
      return if name.empty?
      current_entry = @repository.find { |entry| entry['name'] == name }
      return unless current_entry
      entry = @repository.element_at(cs, current_entry.id)
      puts "warning: you are viewing #{name} as at #{cs}, any changes you make will be discarded"
      Shh::EntryMenu.new(@io, entry).push
    end
  end
end
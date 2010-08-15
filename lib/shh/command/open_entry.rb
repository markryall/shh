require 'uuidtools'
require 'shh/entry_menu'

class Shh::Command::OpenEntry
  attr_reader :usage, :help

  def initialize repository, io
    @repository, @io = repository, io
    @usage = "<entry name>"
    @help = "Enters a subshell for editing the specifed entry"
  end

  def completion text
    @repository.map{|entry| entry['name']}.grep(/^#{text}/).sort || []
  end

  def execute name=nil
    return unless name
    return if name.empty?
    entry = @repository.find { |entry| entry['name'] == name }
    entry ||= {'name' => name, 'id' => UUIDTools::UUID.random_create.to_s }
    Shh::EntryMenu.new(@io, entry).push
    @repository[entry['id']] = entry
  end
end
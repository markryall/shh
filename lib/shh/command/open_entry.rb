require 'uuidtools'
require 'shh/entry_menu'

class Shh::Command::OpenEntry
  def initialize repository, io
    @repository, @io = repository, io
  end

  def completion text
    @repository.map{|entry| entry['name']}.grep(/^#{text}/).sort || []
  end

  def execute name=nil
    entry = @repository.find_by_name(name)
    entry ||= {'name' => name, 'id' => UUIDTools::UUID.random_create.to_s}
    Shh::EntryMenu.new(@io, entry).push
    @repository.persist entry
  end
end
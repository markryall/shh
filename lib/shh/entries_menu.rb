require 'uuidtools'
require 'shh/clipboard'

module Shh
  class EntriesMenu
    def initialize repository
      @repository = repository
      @clipboard = Shh.clipboard
    end

    def main_loop
      loop do
        choose do |menu|
          menu.layout = :menu_only
          menu.shell  = true
          menu.choice('list entries') { list }
          menu.choice('edit entry') { |command, details| edit details }
          menu.choice('view entry') { |command, details| view details }
          menu.choice('quit') { exit }
        end
      end
    end

    def list
      @repository.each_entry {|entry| say "#{entry['name']} (#{entry['id']})" }
    end

    def edit name=''
      entry = @repository.find_entry(check_name(name))
      entry ||= {'name' => check_name(name), 'id' => UUIDTools::UUID.random_create.to_s}
      @repository.persist_entry prompt_loop(entry)
    end

    def view name=''
      prompt_loop @repository.find_entry(check_name(name)), true
    end
private

    def check_name name
      name = ask('Enter the entry name') unless name.size > 0
      name
    end

    def prompt_loop hash, read_only=false
      loop do
        choose do |menu|
          menu.layout = :menu_only
          menu.shell  = true
          menu.choice('edit key') { |command, name| hash[name] = new_value(name) } unless read_only
          menu.choice('list keys') { say(hash.keys.sort.join(',')) }
          menu.choice('show key') { |command, name| say(hash[name]) if hash[name] }
          menu.choice('delete key') { |command, name| hash[name] = nil } unless read_only
          menu.choice('copy key') { |command, name| @clipboard.content = hash[name] } if @clipboard
          menu.choice('quit') { return hash }
        end
      end
    end

    def new_value name
      echo = (name =~ /pass/) ? false : true
      ask("Enter new value for #{name}") {|q| q.echo = echo }
    end
  end
end

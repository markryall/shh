require 'uuidtools'
require 'shh/entry_menu'

module Shh
  class EntriesMenu
    def initialize prompt, repository
      @prompt, @repository = prompt, repository
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
      @repository.persist_entry EntryMenu.new(@prompt, entry).main_loop(prompt)
    end

    def view name=''
      EntryMenu.new(@prompt, @repository.find_entry(check_name(name)), true).main_loop
    end

private

    def check_name name
      @prompt.get('Enter the entry name', :value => name)
    end
  end
end

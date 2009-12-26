require 'shh/clipboard'

module Shh
  class EntryMenu
    def initialize prompt, hash, read_only=false
      @prompt, @hash, @read_only = prompt, hash, read_only
      @clipboard = Shh.clipboard
    end

    def main_loop
      loop do
        choose do |menu|
          menu.layout = :menu_only
          menu.shell  = true
          menu.choice('edit key') { |command, name| @hash[name] = new_value(name) } unless @read_only
          menu.choice('list keys') { say(@hash.keys.sort.join(',')) }
          menu.choice('show key') { |command, name| say(@hash[name]) if @hash[name] }
          menu.choice('delete key') { |command, name| @hash[name] = nil } unless @read_only
          menu.choice('copy key') { |command, name| @clipboard.content = @hash[name] } if @clipboard
          menu.choice('quit') { return @hash }
        end
      end
    end

private

    def new_value name
      @prompt.get "Enter new value for #{name}", :silent => (name =~ /pass/)
    end
  end
end

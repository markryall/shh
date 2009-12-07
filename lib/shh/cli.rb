require 'rubygems'
require 'pathname2'
require 'highline/import'
require 'uuid'
require 'shh/crypt'
require 'yaml'
require 'pathname2' # don't ask why i'm loading this twice

module Shh
  class Cli
    def execute *args
      passphrase = ask('Enter your passphrase') { |q| q.echo = false }

      @uuid = UUID.new
      @folder = Pathname.new('secret')
      @folder.mkdir_p
      @crypt = Crypt.new(passphrase)

      loop do
        choose do |menu|
          menu.layout = :menu_only
          menu.shell  = true
          menu.choice('list entries') { list }
          menu.choice('create entry') { |command, details| create details }
          menu.choice('edit entry') { |command, details| edit details }
          menu.choice('view entry') { |command, details| view details }
          menu.choice('quit') { exit }
        end
      end
    end

    def list
      each_entry {|entry| say "#{entry['name']} - #{entry['id']}" }
    end

    def create name=''
      hash = {'name' => check_name(name), 'id' => @uuid.generate}
      persist_entry prompt_loop(hash)
    end

    def edit name=''
      name = check_name(name)
      persist_entry prompt_loop(find_entry(name))
    end

    def view name=''
      prompt_loop find_entry(check_name(name)), true
    end

private

    def each_entry
      @folder.children.each do |child|
        yield load_entry(child)
      end
    end

    def check_name name
      name = ask('Enter the entry name') unless name.size > 0
      name
    end

    def find_entry name
      each_entry {|e| return e if e['name'] == name}
    end

    def load_entry path
      entry = path.open('r') {|io| @crypt.decrypt(io) }
      YAML::load(entry)
    end

    def persist_entry entry
      (@folder + entry['id']).open('w') {|io| @crypt.encrypt(entry.to_yaml, io) }
    end

    def prompt_loop hash, read_only=false
      loop do
        choose do |menu|
          menu.layout = :menu_only
          menu.shell  = true
          menu.choice('create key') { |command, name| hash[name] = new_value(name) } unless read_only
          menu.choice('list keys') { say(hash.keys.sort.join(',')) }
          menu.choice('show key') { |command, name| say(hash[name]) if hash[name] }
          menu.choice('delete key') { |command, name| hash[name] = nil } unless read_only
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
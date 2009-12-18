require 'rubygems'
require 'pathname2'
require 'highline/import'
require 'uuidtools'
require 'yaml'
require 'shh/crypt'
require 'shh/clipboard'

module Shh
  class Cli
    def execute *args
      passphrase = ask('Enter your passphrase') { |q| q.echo = false }

      path = args.shift || ('~')
      @folder = Pathname.new(File.expand_path(path)) + '.secret'
      @folder.mkdir_p
      @crypt = Crypt.new(passphrase)
      @clipboard = Shh.clipboard

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
      each_entry {|entry| say "#{entry['name']} (#{entry['id']})" }
    end

    def edit name=''
      entry = find_entry(check_name(name))
      entry ||= {'name' => check_name(name), 'id' => UUIDTools::UUID.random_create.to_s}
      persist_entry prompt_loop(entry)
    end

    def view name=''
      prompt_loop find_entry(check_name(name)), true
    end

private

    def each_entry
      @folder.children.each do |child|
        entry = load_entry(child)
        yield entry if entry
      end
    end

    def check_name name
      name = ask('Enter the entry name') unless name.size > 0
      name
    end

    def find_entry name
      each_entry {|e| return e if e['name'] == name}
      nil
    end

    def load_entry path
      return nil if path.directory?
      yaml = path.open('rb') {|io| @crypt.decrypt(io) }
      entry = YAML::load(yaml)
      return nil unless entry
      path.basename.to_s == entry['id'] ? entry : nil
    end

    def persist_entry entry
      (@folder + entry['id']).open('wb') {|io| @crypt.encrypt(entry.to_yaml, io) }
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

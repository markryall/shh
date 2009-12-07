require 'rubygems'
require 'pathname2'
require 'highline/import'
require 'shh/crypt'
require 'yaml'

module Shh
  class Cli
    def execute *args
      passphrase = ask('Enter your passphrase') { |q| q.echo = false }

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
      @folder.entries.each do |child|
        say(child) unless ['.','..'].include?(child.to_s)
      end
    end

    def create name=''
      persist_entry check_name(name), prompt_loop({})
    end

    def edit name=''
      name = check_name(name)
      persist_entry name, prompt_loop(load_entry(name))
    end

    def view name=''
      prompt_loop load_entry(check_name(name)), true
    end

private

    def check_name name
      name = ask('Enter the entry name') unless name.size > 0
      name
    end

    def load_entry name
      entry = (@folder + name).open('r') {|io| @crypt.decrypt(io) }
      YAML::load(entry)
    end

    def persist_entry name, entry
      (@folder + name).open('w') {|io| @crypt.encrypt(entry.to_yaml, io) }
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
require 'rubygems'
require 'highline/import'
require 'shh/crypt'

module Shh
  class Cli
    def execute *args
      passphrase = ask('Enter your passphrase') { |q| q.echo = false }

      loop do
        choose do |menu|
          menu.layout = :menu_only
          menu.shell  = true
          menu.choice(:create, "Create a new entry") { |command, details| create details }
          menu.choice(:search, "Search for an entry") { |command, details| search details }
          menu.choice(:quit, "Exit") { exit }
        end
      end
    end

    def create details
      entry = prompt_loop({})
      
      puts 'persisting new entry'
    end

    def search details
      puts 'searching for ' + details
    end
    
    def prompt_loop hash
      loop do
        choose do |menu|
          menu.layout = :menu_only
          menu.shell  = true
          menu.choice(:create, "Create a new key") { |command, details| create details }
          menu.choice(:delete, "Delete a key") { |command, details| search details }
          menu.choice(:quit, "Exit") { return hash }
        end
      end
    end
    
    def new_value name
      ask("Enter new value for #{name}") {|q| q.echo = (name =~ /pass/)}
    end
  end
end
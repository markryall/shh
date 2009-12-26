require 'rubygems'
require 'shh/repository'
require 'shh/entries_menu'
require 'highline/import'

module Shh
  class Cli
    def self.execute *args
      passphrase = ask('Enter your passphrase') { |q| q.echo = false }
      path = args.shift || ('~')

      EntriesMenu.new(Repository.new(passphrase, path)).main_loop
    end
  end
end

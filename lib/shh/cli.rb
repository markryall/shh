require 'rubygems'
require 'shh/repository'
require 'shh/prompt'
require 'shh/entries_menu'

module Shh
  class Cli
    def self.execute *args
      prompt = Prompt.new
      passphrase = prompt.get('Enter your passphrase', :silent => true)
      path = args.shift || ('~')

      EntriesMenu.new(prompt, Repository.new(passphrase, path)).main_loop
    end
  end
end

require 'rubygems'
require 'shh/prompt'
require 'shh/entries_menu'
require 'shh/blowfish_serialiser'
require 'flat_hash/serialiser'
require 'flat_hash/repository'

module Shh
  class Cli
    def self.execute *args
      prompt = Prompt.new
      passphrase = prompt.ask('Enter your passphrase', :silent => true)
      path = args.shift || '~'
      Dir.chdir(File.expand_path(path)) do
        serialiser = BlowfishSerialiser.new(FlatHash::Serialiser.new, passphrase)
        EntriesMenu.new(prompt, FlatHash::Repository.new(serialiser, '.secret')).push
      end
    end
  end
end

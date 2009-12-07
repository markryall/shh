require 'rubygems'
require 'highline/import'

module Shh
  class Cli
    def self.execute args
      passphrase = ask('enter your passphrase') { |q| q.echo = false }
      
    end
  end
end
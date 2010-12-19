require 'crypt/blowfish'

case RUBY_VERSION
  when /^1.9/
    begin
      gem "crypt19", "1.2.1"
    rescue Exception
      puts "on ruby 1.9:\ngem install crypt19"
      exit 1
    end
  when /^1.8/
    begin
      gem "crypt", "1.1.4"
    rescue Exception
      puts "on ruby 1.8:\ngem install crypt19"
      exit 1
    end
  else
    puts "not sure which crypt gem to use for your version of ruby"
    exit 1
end

module Shh
  class BlowfishSerialiser
    def initialize serialiser, passphrase
      @blowfish = ::Crypt::Blowfish.new(passphrase)
      @serialiser = serialiser
    end

    def read io
      decrypted_io = StringIO.new
      while l = io.read(8) do
        decrypted_io.print @blowfish.decrypt_block(l)
      end
      @serialiser.read StringIO.new(decrypted_io.string.gsub("\0",''))
    end

    def write io, hash
      serialised_io = StringIO.new
      @serialiser.write serialised_io, hash
      serialised_io.rewind
      while l = serialised_io.read(8) do
        while l.size < 8 do l += "\0" end
        io.print @blowfish.encrypt_block(l)
      end
    end
  end
end
require 'crypt/blowfish'

module Shh
  class Crypt
    def initialize passphrase
      @blowfish = ::Crypt::Blowfish.new(passphrase)
    end

    def encrypt text, out_io
      in_io = StringIO.new(text)
      while l = in_io.read(8) do
        while l.size < 8 do l += "\0" end
        out_io.print @blowfish.encrypt_block(l)
      end
    end

    def decrypt in_io
      out_io = StringIO.new
      while l = in_io.read(8) do
        out_io.print @blowfish.decrypt_block(l)
      end
      out_io.string.gsub("\0",'')
    end
  end
end
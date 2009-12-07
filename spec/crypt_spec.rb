require File.dirname(__FILE__)+'/spec_helper'

describe Shh::Crypt do
  it 'should encrypt and decrypt a string to the same value if given the correct passphrase' do
    crypt = Shh::Crypt.new('passphrase')

    crypt_io = StringIO.new
    crypt.encrypt('a big secret', crypt_io)

    crypt2_io = StringIO.new(crypt_io.string)
    crypt.decrypt(crypt2_io).should == 'a big secret'
  end
end
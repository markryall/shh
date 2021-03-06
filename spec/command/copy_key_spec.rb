require File.dirname(__FILE__)+'/../spec_helper'

require 'shh/command/copy_key'

describe Shh::Command::CopyKey do
  before do
    @entry = {}
    @command = Shh::Command::CopyKey.new(@entry, nil)
  end
  
  it 'should provide usage' do
    @command.usage.should == '<key name>'
  end

  it 'should call copy key on entry' do
    @entry['foo'] = stub('entry value')
    @entry['foo'].should_receive(:to_clipboard)
    @command.execute 'foo'
  end
end
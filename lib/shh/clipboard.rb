module Shh
  def self.clipboard
     if RUBY_PLATFORM =~ /mswin32/
       require 'shh/win32_clipboard'
       return Win32Clipboard.new
     end
     nil
  end
end

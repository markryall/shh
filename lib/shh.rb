module Shh
  def self.clipboard
     if RUBY_PLATFORM =~ /mswin32/
       require 'shh/win32_clipboard'
       return Win32Clipboard.new
     end
     if RUBY_PLATFORM =~ /darwin10/
       require 'shh/darwin10_clipboard'
       return Darwin10Clipboard.new
     end
     nil
  end

  def self.launcher
     if RUBY_PLATFORM =~ /mswin32/
       require 'shh/win32_launcher'
       return Win32Launcher.new
     end
     if RUBY_PLATFORM =~ /darwin10/
       require 'shh/darwin10_launcher'
       return Darwin10Launcher.new
     end
     nil
  end
end

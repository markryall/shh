require 'win32/clipboard'

class Win32Clipboard
  def content
    Win32::Clipboard.data
  end

  def content= text
    Win32::Clipboard.set_data(text)
  end

  def clear
    Win32::Clipboard.empty
  end
end

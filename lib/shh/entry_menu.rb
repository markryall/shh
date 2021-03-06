require 'shell_shock/context'
require 'shh/commands'

class Shh::EntryMenu
  include Shh::Command
  include ShellShock::Context

  def initialize io, entry
    @io, @entry = io, entry
    show_command = load_command(:show_key, entry, io)
    edit_command = load_command(:edit_key, entry, io)
    @commands = {
      'ls'     => load_command(:list_keys, entry, io),
      'set'    => load_command(:set_key, entry, io),
      'edit'   => edit_command,
      'cat'    => show_command,
      'less'   => show_command,
      'more'   => show_command,
      'cp'     => load_command(:copy_key, entry, io),
      'launch' => load_command(:launch_key, entry, io),
      'rm'     => load_command(:remove_key, entry, io),
      'exec'   => load_command(:execute_key, entry, io)
    }
  end

  def refresh_commands
    @prompt_text = "shh:#{@entry['name']} > "
  end
end
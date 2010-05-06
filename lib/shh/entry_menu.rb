require 'shell_shock/context'
require 'shh/commands'

module Shh::EntryMenu
  include ShellShock::Context

  def initialize io, entry
    @io, @entry = io, entry
    @commands = {
      'ls'     => Command.load(:list_keys, entry, io),
      'set'    => Command.load(:set_key, entry, io),
      'edit'   => Command.load(:edit_key, entry, io),
      'cat'    => Command.load(:show_key, entry, io),
      'cp'     => Command.load(:copy_key, entry, io),
      'launch' => Command.load(:launch_key, entry, io),
      'rm'     => Command.load(:remove_key, entry, io),
      'exec'   => Command.load(:execute_key, entry, io)
    }
  end

  def refresh_commands
    @prompt_text = "shh:#{@entry['name']} > "
  end
end
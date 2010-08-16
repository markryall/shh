require 'shell_shock/context'
require 'shh/commands'

class Shh::EntriesMenu
  include Shh::Command
  include ShellShock::Context

  def initialize io, repository
    @io, @repository = io, repository
    @prompt_text = 'shh > '
    @commands = {
      'ls'   => load_command(:list_entries, @repository, @io),
      'cd'   => load_command(:open_entry, @repository, @io),
      'history' => load_command(:show_history, @repository, @io),
      'exhume' => load_command(:exhume_entry, @repository, @io),
    }
  end
end
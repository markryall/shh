require 'shell_shock/context'
require 'shh/commands'

class Shh::EntriesMenu
  include Shh::Command
  include ShellShock::Context

  def initialize prompt, repository
    @prompt, @repository = prompt, repository
    @prompt_text = 'shh > '
    @commands = {
      'ls'   => load_command(:list_entries, @repository, @prompt),
      'cd'   => load_command(:open_entry, @repository, @prompt)
    }
  end
end
require 'shell_shock/context'
require 'shh/commands'

module Shh::EntriesMenu
  include ShellShock::Context

  def initialize prompt, repository
    @prompt, @repository = prompt, repository
    @prompt_text = 'shh > '
    @commands = {
      'ls'   => Command.load(:list_entries, @repository, @prompt),
      'cd'   => Command.load(:open_entry, @repository, @prompt)
    }
  end
end
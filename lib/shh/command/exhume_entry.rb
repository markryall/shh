require 'uuidtools'
require 'shh/command/historic_entry_command'
require 'shh/entry_menu'

class Shh::Command::ExhumeEntry
  include Shh::Command::HistoricEntryCommand

  def help
    "Enters a subshell for viewing the specifed entry as it was at the specified revision\nRevision is a number representing the number of changesets to go back in history (ie. 0 is the most recently committed version)"
  end

  def execute text=nil
    with_current_and_historic_entry(text) do |current, changeset, historic|
      puts "warning: you are viewing #{historic['name']} as at #{changeset.id}, any changes you make will be discarded"
      Shh::EntryMenu.new(@io, historic).push
    end
  end
end
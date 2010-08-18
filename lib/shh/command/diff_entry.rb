require 'active_support/core_ext/hash'
require 'shh/command/historic_entry_command'
  
class Shh::Command::DiffEntry
  include Shh::Command::HistoricEntryCommand

  def help
    "Displays changes made since the specified revision of the entry\nRevision is a number representing the number of changesets to go back in history (ie. 0 is the most recently committed version)"
  end

  def execute text=nil
    with_current_and_historic_entry(text) do |current, changeset, historic|
      diff = current.diff(historic)
      if diff.empty?
        puts "no changes"
      else
        added = current.keys - historic.keys
        removed = historic.keys-current.keys
        modified = diff.keys - (added + removed)
        puts "added #{added.join(',')}" unless added.empty?
        puts "removed #{removed.join(',')}" unless removed.empty?
        puts "modified #{modified.join(',')}" unless modified.empty?
      end
    end
  end
end
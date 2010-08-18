module Shh::Command::HistoricEntryCommand
  def initialize repository, io
    @repository, @io = repository, io
  end

  def usage
    "<entry name> <revision>"
  end

  def completion text
    @repository.map{|entry| entry['name']}.grep(/^#{text}/).sort || []
  end
private
  def with_current_and_historic_entry text
    if text =~ /^(.*) (\d+)$/
      name, rev = $1, $2.to_i
      return unless name
      return if name.empty?
      current = @repository.find { |entry| entry['name'] == name }
      return unless current
      cs = @repository.history(current.id)[rev]
      return unless cs
      yield current, cs, @repository.element_at(cs.id, current.id)
    end
  end
end
class Shh::Command::CommitChanges
  attr_reader :help

  def initialize repository, io
    @io, @repository = io, repository
    @help = "Commits all pending changes to vcs (note that this will add _all_ pending changes not only cards)"
    @usage = "<commit message>"
  end

  def execute text=nil
    @repository.addremovecommit text
  end
end
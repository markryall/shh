require 'pathname2'
require 'yaml'
require 'shh/crypt'

module Shh
  class Repository
    attr_reader :folder

    def initialize passphrase, path
      @folder = Pathname.new(File.expand_path(path)) + '.secret'
      @folder.mkdir_p
      @crypt = Crypt.new(passphrase)
    end

    def each_entry
      @folder.children.each do |child|
        entry = load_entry(child)
        yield entry if entry
      end
    end

    def find_entry name
      each_entry {|e| return e if e['name'] == name}
      nil
    end

    def load_entry path
      return nil if path.directory?
      yaml = path.open('rb') {|io| @crypt.decrypt(io) }
      entry = YAML::load(yaml)
      return nil unless entry
      path.basename.to_s == entry['id'] ? entry : nil
    end

    def persist_entry entry
      (@folder + entry['id']).open('wb') {|io| @crypt.encrypt(entry.to_yaml, io) }
    end
  end
end

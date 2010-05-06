require 'yaml'
require 'shh/crypt'
require 'fileutils'

module Shh
  class Repository
    include Enumerable

    attr_reader :folder

    def initialize passphrase, path
      @folder = Pathname.new(File.expand_path(path)) + '.secret'
      @folder.mkpath
      @crypt = Crypt.new(passphrase)
    end

    def each
      @folder.children.each do |child|
        entry = load(child)
        yield entry if entry
      end
    end

    def find_by_name name
      each {|e| return e if e['name'] == name}
      nil
    end

    def load path
      return nil if path.directory?
      yaml = path.open('rb') {|io| @crypt.decrypt(io) }
      entry = YAML::load(yaml)
      return nil unless entry
      path.basename.to_s == entry['id'] ? entry : nil
    end

    def persist entry
      (@folder + entry['id']).open('wb') {|io| @crypt.encrypt(entry.to_yaml, io) }
    end
  end
end

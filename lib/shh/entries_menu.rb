require 'uuidtools'
require 'readline'
require 'shh/entry_menu'

module Shh
  class EntriesMenu
    def initialize prompt, repository
      @prompt, @repository = prompt, repository
      refresh
    end

    def main_loop
      prompt_text = ' > '

      begin
        while line = Readline.readline(prompt_text, true).strip
          case line
            when 'quit'
              return
            when 'refresh'
              refresh
            when 'list'
              list
            when /^view (.*)/
              view $1
            when /^edit (.*)/
              edit $1
          end
        end
      rescue Interrupt => e
        return
      end
    end

    def refresh
      commands = ['list', 'refresh', 'quit']
      @repository.each_entry do |entry|
        commands << "edit #{entry['name']}"
        commands << "view #{entry['name']}"
      end
      Readline.completion_proc = lambda do |text|
        commands.grep( /^#{Regexp.escape(text)}/ ).sort
      end
      Readline.completer_word_break_characters = ''
    end

    def list
      @repository.each_entry {|entry| say "#{entry['name']} (#{entry['id']})" }
    end

    def edit name
      entry = @repository.find_entry(name)
      entry ||= {'name' => name, 'id' => UUIDTools::UUID.random_create.to_s}
      @repository.persist_entry EntryMenu.new(@prompt, entry).main_loop
      refresh
    end

    def view name
      EntryMenu.new(@prompt, @repository.find_entry(name), true).main_loop
      refresh
    end
  end
end
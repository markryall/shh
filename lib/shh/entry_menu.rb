require 'shh/clipboard'

module Shh
  class EntryMenu
    def initialize prompt, hash, read_only=false
      @prompt, @hash, @read_only = prompt, hash, read_only
      @clipboard = Shh.clipboard
      refresh
    end

    def main_loop
      Readline.completion_proc = @completion
      Readline.completer_word_break_characters = ''
      prompt = "(#{@hash['name']}) > "

      begin
        while line = Readline.readline(prompt, true).strip
          case line
            when 'quit'
              return @hash
            when 'list'
              say(@hash.keys.sort.join(','))
            when /^edit (.*)/
              name = $1
              @hash[name] = new_value(name) unless @read_only
            when /^copy (.*)/
              name = $1
              @clipboard.content = @hash[name] if @clipboard and @hash[name]
            when /^delete (.*)/
              name = $1
              @hash.delete(name) unless @read_only
            when /^show (.*)/
              name = $1
              say(@hash[name]) if @hash[name]
          end
        end
      rescue Interrupt => e
        return @hash
      end
    end

private

    def refresh
      commands = ['list', 'quit']
      @hash.keys.each do |key|
        commands << "edit #{key}" unless @read_only
        commands << "delete #{key}" unless @read_only
        commands << "show #{key}"
        commands << "copy #{key}"
      end
      @completion = lambda do |text|
        commands.grep( /^#{Regexp.escape(text)}/ ).sort
      end
    end

    def new_value name
      @prompt.get "Enter new value for #{name}", :silent => (name =~ /pass/)
    end
  end
end

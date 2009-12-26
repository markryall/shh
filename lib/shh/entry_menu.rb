require 'shh'

module Shh
  class EntryMenu
    def initialize prompt, hash, read_only=false
      @prompt, @hash, @read_only = prompt, hash, read_only
      @clipboard = Shh.clipboard
      @launcher = Shh.launcher
      refresh
    end

    def main_loop
      prompt_text = "shh:#{@hash['name']} > "

      begin
        while line = Readline.readline(prompt_text, true)
          line.strip!
          case line
            when 'quit'
              return @hash
            when 'list'
              say(@hash.keys.sort.join(','))
            when /^edit,(.*)/
              edit $1
            when /^copy,(.*)/
              copy $1
            when /^launch,(.*)/
              launch $1
            when /^delete,(.*)/
              delete $1
            when /^view,(.*)/
              view $1
          end
        end
      rescue Interrupt => e
        exit
      end

      puts
      @hash
    end

private

    def can_copy? key
     @clipboard and @hash[key]
    end

    def can_edit?
      !@read_only
    end

    def can_launch? key
      @launcher and @hash[key] =~ /^http/
    end

    def view key
      say(@hash[key]) if @hash[key]
    end

    def copy key
      @clipboard.content = @hash[key] if can_copy?(key) 
    end

    def edit key
      if can_edit?
        @hash[key] = new_value(key)
        refresh
      end
    end

    def delete key
      if can_edit?
        @hash.delete(key)
        refresh
      end
    end

    def launch key
      @launcher.launch @hash[key] if can_launch?(key)
    end

    def refresh
      commands = ['list', 'quit']
      @hash.keys.each do |key|
        commands << "edit,#{key}" if can_edit?
        commands << "delete,#{key}" if can_edit?
        commands << "view,#{key}"
        commands << "copy,#{key}" if can_copy?(key)
        commands << "launch,#{key}" if can_launch?(key)
      end
      Readline.completion_proc = lambda do |text|
        commands.grep( /^#{Regexp.escape(text)}/ ).sort
      end
    end

    def new_value key
      @prompt.get "Enter new value for #{key}", :silent => (key =~ /pass/)
    end
  end
end

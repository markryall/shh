require 'splat'

module Shh
  class EntryMenu
    def initialize prompt, hash, read_only=false
      @prompt, @hash, @read_only = prompt, hash, read_only
      @splat = Splat.new
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
            when /^set (.*)/
              set $1
            when /^edit (.*)/
              edit $1
            when /^copy (.*)/
              copy $1
            when /^launch (.*)/
              launch $1
            when /^delete (.*)/
              delete $1
            when /^view (.*)/
              view $1
            when /^run (.*)/
              run $1
            else
              puts "I can't imagine what you mean by that" 
          end
        end
      rescue Interrupt => e
        exit
      end

      puts
      @hash
    end

private
    def can_edit?
      !@read_only
    end

    def can_launch? key
      @splat.supported? and @hash[key] =~ /^http/
    end

    def can_run? key
      @splat.supported? and @hash[key] =~ /^#!\/usr\/bin\/env ruby/
    end

    def view key
      say(@hash[key]) if @hash[key]
    end

    def copy key
      @splat.clipboard = @hash[key] 
    end

    def run key
      begin
        hash = @hash
        splat = @splat
        eval @hash[key]
      rescue Exception => e
        puts e.message
        e.backtrace.each {|t| puts " > #{t}" }
      end
    end

    def set key
      if can_edit?
        set_value key
        refresh
      end
    end

    def edit key
      if can_edit?
        edit_value key
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
      @splat.launch @hash[key] if can_launch?(key)
    end

    def refresh
      commands = ['list', 'quit']
      @hash.keys.each do |key|
        commands << "edit #{key}" if can_edit?
        commands << "set #{key}" if can_edit?
        commands << "delete #{key}" if can_edit?
        commands << "view #{key}"
        commands << "copy #{key}" if @splat.supported?
        commands << "launch #{key}" if can_launch?(key)
        commands << "run #{key}" if can_run?(key)
      end
      Readline.completion_proc = lambda do |text|
        commands.grep( /^#{Regexp.escape(text)}/ ).sort
      end
      Readline.completer_word_break_characters = ''
    end

    def set_value key
      new_value = @prompt.get("Enter new value for #{key}", :silent => (key =~ /pass/))
      @hash[key] = new_value if new_value.length > 0
    end
    
    def edit_value key
      tmp_file = Pathname.new("key.tmp")
      begin
        tmp_file.open('w') { |out| out.print @hash[key] }
        editor = ENV["EDITOR"] || "notepad"
        system("#{editor} key.tmp")
        return unless $?.to_i == 0
        new_value = tmp_file.read
        @hash[key] = new_value if new_value.length > 0
      ensure
        tmp_file.unlink
      end
    end
  end
end

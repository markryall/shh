require 'highline/import'

module Shh
  class Prompt
    def ask text, params={}
       echo = params[:silent] ? false : true
       Kernel.ask(text) { |q| q.echo = echo }
    end

    def say text=''
      puts text
    end
  end
end

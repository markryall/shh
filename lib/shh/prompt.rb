require 'highline/import'

module Shh
  class Prompt
    def ask text, params={}
       return params[:value] if params[:value] and params[:value].size > 0
       echo = params[:silent] ? false : true
       Kernel.ask(text) { |q| q.echo = echo }
    end
    
    def say text
      puts text
    end
  end
end

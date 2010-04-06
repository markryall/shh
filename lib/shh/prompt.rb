require 'highline/import'

module Shh
  class Prompt
    def get text, params={}
       return params[:value] if params[:value] and params[:value].size > 0
       echo = params[:silent] ? false : true
       ask(text) { |q| q.echo = echo }
    end
  end
end

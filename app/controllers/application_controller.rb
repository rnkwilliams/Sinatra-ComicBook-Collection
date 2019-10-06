require './config/environment'
require 'sinatra/base'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  
  get "/" do
    erb :welcome
  end

end

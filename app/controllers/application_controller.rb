require './config/environment'
require 'sinatra/base'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  
  get "/" do
    erb :welcome
  end

  helpers do
    def current_user
        @user ||= User.find(session[:user_id])
    end

    def logged_in?
        !!session[:user_id]
    end
  end
end

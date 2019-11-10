require './config/environment'
require 'sinatra/base'
require 'rack-flash'

class ApplicationController < Sinatra::Base
   use Rack::Flash
    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, "secret"
      end

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

    def redirect_if_not_logged_in
      if !logged_in?
        flash[:message] = "Please log in first."
          redirect to '/login'
      end
    end
  end
end

require './config/environment'
require 'sinatra/base'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  
  get "/" do
    erb :welcome
  end

  helpers do
    def current_user(session_hash)
        @user ||= User.find(session_hash[:user_id])
    end

    def is_logged_in?(session_hash)
        !!session_hash[:user_id]
    end
end

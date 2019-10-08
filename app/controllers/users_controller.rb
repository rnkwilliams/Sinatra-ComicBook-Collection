require './config/environment'

class UsersController < ApplicationController
    use Rack::Flash
    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, "secret"
      end
  
  get '/signup' do
    if logged_in?
        redirect to '/comics'
    end

    erb :"/users/create_user"
  end
  
  post '/signup' do
    params.each do |label, input|
        if input.empty?
            flash[:new_user_error] = "Please enter #{label}."
            redirect to '/signup'
        end
     end

     user = User.create(:username => params["username"], :email => params["email"], :password => params["password"])
     session[:user_id] = user.id

     redirect to '/comics'
  end

  get '/login' do
    if logged_in?
        redirect to '/comics'
    else
        erb :"users/login"
    end
  end

  post '/login' do
    user = User.find_by(:username => params["username"])

    if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect to '/comics'
    else
        flash[:message] = "Incorrect login. Please try again."
        redirect to '/login'
    end
  end

  get '/users/:slug' do
    slug = params[:slug]
    @user = User.find_by_slug(slug)
    erb :"users/show"
  end

  get '/logout' do
    if logged_in?
        session.clear
        redirect to "/login"
    else
        redirect to '/'
    end
  end
end
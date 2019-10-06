require './config/environment'

class ComicBooksController < ApplicationController
    use Rack::Flash
    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, "secret"
      end
  
    get '/comics' do 
        if !Helpers.is_logged_in?(session)
            redirect to '/login'
        end
        @comics = ComicBook.all
        @user = Helpers.current_user(session)
        erb :"/comic_books/comics"
    end

    get '/comics/new' do
        if !Helpers.is_logged_in?(session)
            redirect to '/login'
        end
            erb :"/comics/new"
    end

end
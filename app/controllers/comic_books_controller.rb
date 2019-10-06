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
            erb :"/comic_books/new"
    end

    post '/comics' do
        user = Helpers.current_user(session)
        params.each do |label, input|
            if input.empty?
                flash[:message] = "Please enter the #{label} of your comic book."
                redirect to '/comics/new'
            end
        end
        comic = ComicBook.create(:title => params["title"], :volume => params["volume"], :publisher => params["publisher"], :year => params["year"], :user_id => user.id)

        redirect to "/comics"
    end

    
        


end
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

    get '/comics/:id' do
        if !Helpers.is_logged_in?(session)
            redirect to '/login'
        end
        @comic = ComicBook.find(params[:id])
        erb :'comic_books/show_comic'
    end
        
    get '/comics/:id/edit' do
        if !Helpers.is_logged_in?(session)
          redirect to '/login'
        end
        @comic = ComicBook.find(params[:id])
        if Helpers.current_user(session).id != @comic.user_id
          flash[:message] = "Sorry you can only edit your own comic books"
          redirect to '/comics'
        end
        erb :"comics/edit_comic"
      end
  
      

end
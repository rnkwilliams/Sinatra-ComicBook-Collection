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
        if !logged_in?
            redirect to '/login'
        end
        @user = current_user
        @comics = @user.comic_books
        erb :"/comic_books/comics"
    end

    get '/comics/new' do
        if !logged_in?
            redirect to '/login'
        end
            erb :"/comic_books/new"
    end

    post '/comics' do
        user = current_user
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
        if !logged_in?
            redirect to '/login'
        end
        @comic = ComicBook.find(params[:id])
        erb :'comic_books/show_comic'
    end
        
    get '/comics/:id/edit' do
        if !logged_in?
          redirect to '/login'
        end
        @comic = ComicBook.find(params[:id])
        if current_user.id != @comic.user_id
          flash[:wrong_user_edit] = "Sorry you can only edit your own comic book."
          redirect to '/comics'
        end
        erb :"comic_books/edit_comic"
      end
  
    patch '/comics/:id' do
        comic = ComicBook.find(params[:id])
        params.each do |label, input|
            if input.empty?
                flash[:message] = "Please enter the #{label} of your comic book."
                redirect to '/comics/#{params[:id]}/edit'
            end
        end
        comic.update(:title => params["title"], :volume => params["volume"], :publisher => params["publisher"], :year => params["year"])
        comic.save
    
        redirect to "/comics/#{comic.id}"
    end
    
    delete '/comics/:id/delete' do
        if !logged_in?
          redirect to '/login'
        end
        @comic = ComicBook.find(params[:id])
        if current_user.id != @comic.user_id
          flash[:wrong_user] = "Sorry you can only delete your own comic book."
          redirect to '/comics'
        end
        @comic.delete
        redirect to '/comics'
      end
end
class UsersController < ApplicationController

    get '/' do
        erb :'users/homepage'
      end

      get '/signup' do
        # binding.pry
        if Helpers.logged_in?(session)
            redirect "/tweets"
        end
        erb :'users/signup'
      end

      post '/signup' do
        if params[:username] == "" || params[:password] == "" || params[:email] == ""
            redirect "/signup"
        else
            # binding.pry
            user = User.create(username: params[:username], password: params[:password], email: params[:email])
            session[:user_id] = user.id
            redirect "/tweets"
        end
      end

      get '/login' do
        if Helpers.logged_in?(session)
            redirect "/tweets"
        else
            erb :'users/login'
        end
        
      end

      post "/login" do
        # binding.pry
        user = User.find_by(username: params[:username])
        if user && user.authenticate(params[:password])
          session[:user_id] = user.id
          redirect "/tweets"
        else
          redirect "/login"
        end
      end

      get '/logout' do
        # binding.pry
        if Helpers.logged_in?(session)
            session.clear
        end
            redirect "/login"
      end

      get '/users/:slug' do
        @user = User.find_by_slug(params[:slug])
        @tweets = @user.tweets
        erb :'users/show'
      end

end

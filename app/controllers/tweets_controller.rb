class TweetsController < ApplicationController

    get '/tweets' do
        if !Helpers.logged_in?(session)
            redirect "/login"
        else
            @user = User.find(session[:user_id])
            @tweets = Tweet.all
            erb :'tweets/index'
        end
    end

    get '/tweets/new' do
        if Helpers.logged_in?(session)
            erb :'tweets/new'
        else
            redirect "/login"
        end
    end

    post '/tweets' do
        if params[:content].empty?
            redirect "/tweets/new"
        elsif Helpers.logged_in?(session)
            tweet = Tweet.create(content: params[:content], user_id: session[:user_id])
            redirect "/tweets/#{tweet.id}"
        else
            redirect "/login"
        end
    end

    get '/tweets/:id' do
        @tweet = Tweet.all.find(params[:id])
        if !Helpers.logged_in?(session)
            redirect "/login"
        else
            erb :'tweets/show'
        end
    end

    get '/tweets/:id/edit' do
        if !Helpers.logged_in?(session)
            redirect "/login"
        else
            @tweet = Tweet.find(params[:id])
            if @tweet.user_id != session[:user_id]
                redirect "/tweets/#{params[:id]}"
            else
                erb :'tweets/edit'
            end
        end
    end

    patch '/tweets/:id' do
        if !Helpers.logged_in?(session)
            redirect "/login"
        else
            @tweet = Tweet.find(params[:id])
            if @tweet.user_id != session[:user_id]
                redirect "/tweets/#{@tweet.id}"
            elsif params[:content].empty?
                redirect "/tweets/#{@tweet.id}/edit"
            else
                @tweet.update(content: params[:content])
                redirect "/tweets/#{@tweet.id}/edit"
            end
        end
    end

    delete '/tweets/:id' do
        @tweet = Tweet.find(params[:id])
        if @tweet.user_id == session[:user_id]
            @tweet.destroy
            redirect "/tweets"
        else
            redirect "/tweets/#{@tweet.id}"
        end
    end

end

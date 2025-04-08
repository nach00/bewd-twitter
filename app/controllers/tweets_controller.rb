class TweetsController < ApplicationController
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
  before_action :authenticate_user, only: [:create, :destroy]
  
  def create
    tweet = @current_user.tweets.new(tweet_params)
    
    if tweet.save
      render json: { 
        tweet: {
          username: @current_user.username,
          message: tweet.message
        }
      }, status: :created
    else
      render json: { errors: tweet.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def index
    tweets = Tweet.all.order(created_at: :desc)
    
    render json: { 
      tweets: tweets.map do |tweet|
        {
          id: tweet.id,
          username: tweet.user.username,
          message: tweet.message
        }
      end
    }
  end
  
  def index_by_user
    user = User.find_by(username: params[:username])
    
    if user
      tweets = user.tweets.order(created_at: :desc)
      
      render json: { 
        tweets: tweets.map do |tweet|
          {
            id: tweet.id,
            username: user.username,
            message: tweet.message
          }
        end
      }
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end
  
  def destroy
    tweet = Tweet.find(params[:id])
    
    if tweet.user_id == @current_user.id
      tweet.destroy
      render json: { success: true }
    else
      render json: { success: false }
    end
  end
  
  private
  
  def tweet_params
    params.require(:tweet).permit(:message)
  end
  
  def authenticate_user
    token = request.headers['X-Auth-Token'] || cookies.signed['twitter_session_token']
    session = Session.find_by(token: token)
    
    if session
      @current_user = session.user
    else
      render json: { success: false }, status: :unauthorized
    end
  end
end

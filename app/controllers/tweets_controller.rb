# app/controllers/tweets_controller.rb
class TweetsController < ApplicationController
  def create
    token = cookies.permanent[:twitter_session_token]
    session = Session.find_by(token: token)

    if session
      @tweet = session.user.tweets.new(tweet_params)

      if @tweet.save
        render json: { tweet: @tweet }
      else
        render json: { errors: @tweet.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { success: false }, status: :unauthorized
    end
  end

  def destroy
    token = cookies.permanent[:twitter_session_token]
    session = Session.find_by(token: token)

    if session
      @tweet = Tweet.find(params[:id])

      if @tweet.user_id == session.user_id
        @tweet.destroy
        render json: { success: true }
      else
        render json: { success: false }, status: :unauthorized
      end
    else
      render json: { success: false }, status: :unauthorized
    end
  end

  def index
    @tweets = Tweet.all.order(created_at: :desc)
    render 'tweets/index'
  end

  def index_by_user
    @user = User.find_by(username: params[:username])

    if @user
      @tweets = @user.tweets.order(created_at: :desc)
      render 'tweets/index'
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:message)
  end
end

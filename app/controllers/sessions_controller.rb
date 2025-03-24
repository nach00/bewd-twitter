# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def create
    @user = User.find_by(username: params[:user][:username])

    if @user && @user.authenticate(params[:user][:password])
      @session = @user.sessions.create
      cookies.permanent[:twitter_session_token] = @session.token

      render json: { success: true }
    else
      render json: { success: false }, status: :unauthorized
    end
  end

  def authenticated
    token = cookies.permanent[:twitter_session_token]
    session = Session.find_by(token: token)

    if session
      render json: { authenticated: true }
    else
      render json: { authenticated: false }, status: :unauthorized
    end
  end

  def destroy
    token = cookies.permanent[:twitter_session_token]
    session = Session.find_by(token: token)

    if session
      session.destroy
      render json: { success: true }
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end
end

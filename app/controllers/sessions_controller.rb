class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
  
  def create
    user = User.find_by(username: params[:user][:username])
    
    if user && user.authenticate(params[:user][:password])
      session = user.sessions.create
      cookies.signed['twitter_session_token'] = session.token
      render json: { success: true }, status: :created
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end
  
  def authenticated
    token = request.headers['X-Auth-Token'] || cookies.signed['twitter_session_token']
    session = Session.find_by(token: token)
    
    if session
      render json: { 
        authenticated: true, 
        username: session.user.username 
      }
    else
      render json: { authenticated: false }
    end
  end
  
  def destroy
    token = request.headers['X-Auth-Token'] || cookies.signed['twitter_session_token']
    session = Session.find_by(token: token)
    
    if session
      # Make sure all sessions are destroyed
      session.user.sessions.destroy_all
      cookies.delete('twitter_session_token')
      render json: { success: true }
    else
      render json: { success: false }
    end
  end
end

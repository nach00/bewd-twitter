class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  
  private
  
  def authenticate_user
    token = request.headers['X-Auth-Token'] || cookies.signed['twitter_session_token']
    session = Session.find_by(token: token)
    
    if session
      @current_user = session.user
      true
    else
      render json: { success: false }, status: :unauthorized
      false
    end
  end
end

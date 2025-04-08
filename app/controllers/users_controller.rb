class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    
    if user.save
      # Only return the specific fields requested in the test
      render json: {
        user: {
          username: user.username,
          email: user.email
        }
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :username, :password)
  end
end

class Api::V0::UsersController < ApplicationController
  def create
    user = User.new(user_info)
    user.save!
    render json: UserSerializer.serialize(user), status: 201
  end

  private
  def user_info
    params.permit(:email, :password, :password_confirmation)
  end
end
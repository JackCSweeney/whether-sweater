class Api::V0::SessionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      render json: UserSerializer.serialize(user)
    else
      not_found_response
    end
  end

  private
  def not_found_response
    render json: ErrorMessageSerializer.serialize(ErrorMessage.new("Error: Email/Password incorrect", 401)), status: 401
  end
end
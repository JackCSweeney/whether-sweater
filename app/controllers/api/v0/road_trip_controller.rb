class Api::V0::RoadTripController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :no_key_response

  def create
    user = User.find_by(api_key: params[:api_key])
    if user
      road_trip = RoadTripFacade.get_road_trip(road_trip_params)
      render json: RoadTripSerializer.new(road_trip), status: 201
    else
      no_key_response
    end
  end

  private
  def road_trip_params
    params.permit(:origin, :destination)
  end

  def no_key_response
    render json: ErrorMessageSerializer.serialize(ErrorMessage.new("Error: API Key missing or invalid", 401)), status: 401
  end
end
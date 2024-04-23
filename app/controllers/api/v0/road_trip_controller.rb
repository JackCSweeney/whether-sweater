class Api::V0::RoadTripController < ApplicationController
  def create
    user = User.find_by(api_key: params[:api_key])
    road_trip = RoadTripFacade.get_road_trip(road_trip_params)
    render json: RoadTripSerializer.new(road_trip), status: 201
  end

  private
  def road_trip_params
    params.permit(:origin, :destination)
  end
end
class Api::V0::ForecastController < ApplicationController
  def show
    if valid_location
      coords = MapQuestFacade.get_coords(params[:location])
      forecast = ForecastFacade.make_forecast(coords)
      render json: ForecastSerializer.new(forecast), status: :ok
    else
      render json: ErrorMessageSerializer.serialize(ErrorMessage.new("Error: Unable to process request", 422)), status: 422
    end
  end

  private
  def valid_location
    !params[:location].empty?
  end
end
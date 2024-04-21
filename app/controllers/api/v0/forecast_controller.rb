class Api::V0::ForecastController < ApplicationController
  def show
    coords = MapQuestFacade.get_coords(params[:location])
    forecast = ForecastFacade.get_forecast(coords)
    render json: ForecastSerializer.serialize(forecast), status: :ok
  end
end
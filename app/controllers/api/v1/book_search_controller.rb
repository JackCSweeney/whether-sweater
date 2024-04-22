class Api::V1::BookSearchController < ApplicationController
  def show
    books = BookFacade.get_and_make_books(params[:location], params[:quantity])
    coords = MapQuestFacade.get_coords(params[:location])
    forecast = ForecastSerializer.serialize(ForecastFacade.get_forecast(coords))
    render json: BookForecastSerializer.serialize(forecast, books, params[:location])
  end
end
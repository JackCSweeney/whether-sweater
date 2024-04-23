class ForecastFacade
  def self.get_forecast(coords)    
    ForecastService.get_forecast(coords)
  end

  def self.make_forecast(coords)
    forecast_data = get_forecast(coords)
    Forecast.new(forecast_data)
  end
end
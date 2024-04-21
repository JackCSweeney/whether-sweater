class ForecastFacade
  def self.get_forecast(coords)    
    ForecastService.get_forecast(coords)
  end
end
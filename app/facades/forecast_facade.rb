class ForecastFacade
  def self.get_forecast(city_state)
    coords = MapQuestFacade.get_coords(city_state)
    ForecastService.get_forecast(coords)
  end
end
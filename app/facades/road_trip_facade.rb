class RoadTripFacade
  def self.get_road_trip(params)
    origin_coords = MapQuestFacade.get_coords(params[:origin])
    dest_coords = MapQuestFacade.get_coords(params[:destination])
    create_road_trip(origin_coords, dest_coords, params[:origin], params[:destination])
  end

  def self.create_road_trip(origin_coords, dest_coords, origin, destination)
    directions = get_directions(origin_coords, dest_coords)
    forecast = ForecastFacade.get_forecast(dest_coords)
    road_trip_data = {directions: directions, forecast: forecast, origin: origin, destination: destination}
    RoadTrip.new(road_trip_data)
  end

  def self.get_directions(origin_coords, dest_coords)
    MapQuestFacade.get_directions(origin_coords, dest_coords)
  end
end
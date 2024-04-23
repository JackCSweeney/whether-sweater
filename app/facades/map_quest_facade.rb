class MapQuestFacade
  def self.get_coords(city_state)
    response = MapQuestService.get_coords(city_state)
    parse_for_coords(response)
  end

  def self.parse_for_coords(response)
    lat = response[:results].first[:locations].first[:latLng][:lat]
    lng = response[:results].first[:locations].first[:latLng][:lng]
    "#{lat},#{lng}"
  end

  def self.get_directions(origin_coords, dest_coords)
    MapQuestService.get_directions(origin_coords, dest_coords)
  end
end
class MapQuestService
  def self.get_coords(city_state)
    response = get_url(city_state)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn 
    Faraday.new("https://www.mapquestapi.com")
  end

  def self.get_url(city_state)
    conn.get("/geocoding/v1/address") do |req|
      req.params[:location] = "#{city_state}"
      req.params[:key] = Rails.application.credentials.map_quest_key
    end
  end
end
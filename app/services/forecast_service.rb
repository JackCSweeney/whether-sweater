class ForecastService
  def self.get_forecast(coords)
    response = get_forecast_data(coords)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn
    Faraday.new("http://api.weatherapi.com")
  end

  def self.get_forecast_data(coords)
    conn.get("/v1/forecast.json") do |req|
      req.params[:key] = Rails.application.credentials.weather_api
      req.params[:q] = coords
      req.params[:days] = "5"
      req.params[:aqi] = "no"
      req.params[:alerts] = "no"
    end
  end
end
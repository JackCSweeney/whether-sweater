class Forecast
  attr_reader :current_weather, :daily_weather, :hourly_weather

  def initialize(forecast_data)
    @current_weather = get_current_weather(forecast_data)
    @daily_weather = get_daily_weather(forecast_data)
    @hourly_weather = get_hourly_weather(forecast_data)
  end

  def get_current_weather(forecast_data)
    {
      last_updated: forecast_data[:current][:last_updated],
      temperature: forecast_data[:current][:temp_f],
      feels_like: forecast_data[:current][:feelslike_f],
      humidity: forecast_data[:current][:humidity],
      uvi: forecast_data[:current][:uv],
      visibility: forecast_data[:current][:vis_miles],
      condition: forecast_data[:current][:condition][:text],
      icon: forecast_data[:current][:condition][:icon]
    }
  end

  def get_daily_weather(forecast_data)
    forecast_data[:forecast][:forecastday].map do |day|
      {
        date: day[:date],
        sunrise: day[:astro][:sunrise],
        sunset: day[:astro][:sunset],
        max_temp: day[:day][:maxtemp_f],
        min_temp: day[:day][:mintemp_f],
        condition: day[:day][:condition][:text],
        icon: day[:day][:condition][:icon]
      }
    end
  end

  def get_hourly_weather(forecast_data)
    forecast_data[:forecast][:forecastday].first[:hour].map do |hour|
      {
        time: hour[:time],
        temperature: hour[:temp_f],
        condition: hour[:condition][:text],
        icon: hour[:condition][:icon]
      }
    end
  end
end
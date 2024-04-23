class ForecastSerializer
  include JSONAPI::Serializer
  attributes :current_weather, :daily_weather, :hourly_weather, :id

  # def self.serialize(forecast)
  #   {
  #     data: {
  #       id: nil,
  #       type: "forecast",
  #       attributes: {
  #         current_weather: {
  #           last_updated: forecast[:current][:last_updated],
  #           temperature: forecast[:current][:temp_f],
  #           feels_like: forecast[:current][:feelslike_f],
  #           humidity: forecast[:current][:humidity],
  #           uvi: forecast[:current][:uv],
  #           visibility: forecast[:current][:vis_miles],
  #           condition: forecast[:current][:condition][:text],
  #           icon: forecast[:current][:condition][:icon]
  #         },
  #         daily_weather: make_daily_weather(forecast[:forecast][:forecastday]),
  #         hourly_weather: make_hourly_weather(forecast[:forecast][:forecastday].first)
  #       }
  #     }
  #   }
  # end

  # def self.make_daily_weather(forecast_days)
  #   forecast_days.map do |day|
  #     {
  #       date: day[:date],
  #       sunrise: day[:astro][:sunrise],
  #       sunset: day[:astro][:sunset],
  #       max_temp: day[:day][:maxtemp_f],
  #       min_temp: day[:day][:mintemp_f],
  #       condition: day[:day][:condition][:text],
  #       icon: day[:day][:condition][:icon]
  #     }
  #   end
  # end

  # def self.make_hourly_weather(forecast_hours)
  #   forecast_hours[:hour].map do |hour|
  #     {
  #       time: hour[:time],
  #       temperature: hour[:temp_f],
  #       condition: hour[:condition][:text],
  #       icon: hour[:condition][:icon]
  #     }
  #   end
  # end
end
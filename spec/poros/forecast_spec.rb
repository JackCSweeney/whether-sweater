require 'rails_helper'

RSpec.describe Forecast do
  before(:each) do
    json_response = File.read("spec/fixtures/weather/cincinatti_oh_weather_get_request.json")
    forecast_data = JSON.parse(json_response, symbolize_names: true)
    @forecast = Forecast.new(forecast_data)
  end

  describe 'initialize' do
    it 'exists' do
      expect(@forecast).to be_a(Forecast)
    end

    it 'has attributes' do
      expect(@forecast.current_weather).to be_a(Hash)

      current_weather = @forecast.current_weather
      expect(current_weather).to have_key(:last_updated)
      expect(current_weather).to have_key(:temperature)
      expect(current_weather).to have_key(:feels_like)
      expect(current_weather).to have_key(:humidity)
      expect(current_weather).to have_key(:uvi)
      expect(current_weather).to have_key(:visibility)
      expect(current_weather).to have_key(:condition)
      expect(current_weather).to have_key(:icon)

      expect(@forecast.daily_weather).to be_a(Array)

      @forecast.daily_weather.each do |day|
        expect(day).to have_key(:date)
        expect(day).to have_key(:sunrise)
        expect(day).to have_key(:sunset)
        expect(day).to have_key(:max_temp)
        expect(day).to have_key(:min_temp)
        expect(day).to have_key(:condition)
        expect(day).to have_key(:icon)
      end

      expect(@forecast.hourly_weather).to be_a(Array)

      @forecast.hourly_weather.each do |hour|
        expect(hour).to have_key(:time)
        expect(hour).to have_key(:temperature)
        expect(hour).to have_key(:condition)
        expect(hour).to have_key(:icon)
      end
    end
  end
end
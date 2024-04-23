require 'rails_helper'

RSpec.describe ForecastFacade do
  before(:each) do 
    @facade = ForecastFacade
    @coords = "39.10713,-84.50413"

    json_response = File.read("spec/fixtures/weather/cincinatti_oh_weather_get_request.json")

    stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?key=#{Rails.application.credentials.weather_api}&q=#{@coords}&days=5&aqi=no&alerts=no")
      .to_return(status: 200, body: json_response)
  end

  describe '.class methods' do
    describe '.get_forecast(coords)' do
      it 'returns forecast data from the given coordinates' do
        response = @facade.get_forecast(@coords)

        expect(response).to have_key(:location)
        expect(response[:location]).to be_a(Hash)

        expect(response).to have_key(:current)
        expect(response[:current]).to be_a(Hash)

        current = response[:current]
        expect(current).to have_key(:last_updated)
        expect(current[:last_updated]).to be_a(String)
        expect(current).to have_key(:temp_f)
        expect(current[:temp_f]).to be_a(Float)
        expect(current).to have_key(:feelslike_f)
        expect(current[:feelslike_f]).to be_a(Float)
        expect(current).to have_key(:humidity)
        expect(current[:humidity]).to be_a(Integer)
        expect(current).to have_key(:uv)
        expect(current[:uv]).to be_a(Float)
        expect(current).to have_key(:vis_miles)
        expect(current[:vis_miles]).to be_a(Float)
        expect(current).to have_key(:condition)
        expect(current[:condition]).to be_a(Hash)
        expect(current[:condition]).to have_key(:text)
        expect(current[:condition][:text]).to be_a(String)
        expect(current[:condition]).to have_key(:icon)
        expect(current[:condition][:icon]).to be_a(String)
        expect(current[:condition][:icon].include?(".png")).to eq(true)

        expect(response).to have_key(:forecast)
        expect(response[:forecast]).to be_a(Hash)
        expect(response[:forecast]).to have_key(:forecastday)
        expect(response[:forecast][:forecastday]).to be_a(Array)
        expect(response[:forecast][:forecastday].count).to eq(5)

        response[:forecast][:forecastday].each do |forecastday|
          expect(forecastday).to have_key(:date)
          expect(forecastday[:date]).to be_a(String)
          expect(forecastday).to have_key(:day)
          expect(forecastday[:day]).to be_a(Hash)
          expect(forecastday).to have_key(:astro)
          expect(forecastday[:astro]).to be_a(Hash)
          
          day = forecastday[:day]
          expect(day).to have_key(:maxtemp_f)
          expect(day[:maxtemp_f]).to be_a(Float)
          expect(day).to have_key(:mintemp_f)
          expect(day[:mintemp_f]).to be_a(Float)
          expect(day).to have_key(:condition)
          expect(day[:condition]).to be_a(Hash)
          expect(day[:condition]).to have_key(:text)
          expect(day[:condition][:text]).to be_a(String)
          expect(day[:condition]).to have_key(:icon)
          expect(day[:condition][:icon]).to be_a(String)
          expect(day[:condition][:icon].include?(".png")).to eq(true)

          astro = forecastday[:astro]
          expect(astro).to have_key(:sunrise)
          expect(astro[:sunrise]).to be_a(String)
          expect(astro).to have_key(:sunset)
          expect(astro[:sunset]).to be_a(String)
        end

        first_day = response[:forecast][:forecastday].first
        expect(first_day).to have_key(:hour)
        expect(first_day[:hour]).to be_a(Array)
        expect(first_day[:hour].count).to eq(24)

        first_day[:hour].each do |hour|
          expect(hour).to have_key(:time)
          expect(hour[:time]).to be_a(String)
          expect(hour).to have_key(:temp_f)
          expect(hour[:temp_f]).to be_a(Float)
          expect(hour).to have_key(:condition)
          expect(hour[:condition]).to be_a(Hash)
          expect(hour[:condition]).to have_key(:text)
          expect(hour[:condition][:text]).to be_a(String)
          expect(hour[:condition]).to have_key(:icon)
          expect(hour[:condition][:icon]).to be_a(String)
          expect(hour[:condition][:icon].include?(".png")).to eq(true)
        end
      end
    end

    describe '.make_forecast' do
      it 'creates a forecast object from the data' do
        expect(@facade.make_forecast(@coords)).to be_a(Forecast)
      end
    end
  end
end
require 'rails_helper'

RSpec.describe 'Request for Forecast by City' do
  before(:each) do
    @headers = {"CONTENT_TYPE" => "application/json"}
    @location = "cincinatti,oh"
    @coords = "39.10713,-84.50413"

    json_response = File.read("spec/fixtures/geocoding/cincinatti_oh_geocode_response.json")

    stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{Rails.application.credentials.map_quest_key}&location=#{@location}")
      .to_return(status: 200, body: json_response)  

    json_response = File.read("spec/fixtures/weather/cincinatti_oh_weather_get_request.json")

    stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?key=#{Rails.application.credentials.weather_api}&q=#{@coords}&days=5&aqi=no&alerts=no")
      .to_return(status: 200, body: json_response)
  end

  it 'returns the forecast for the given city in the correct format and doesnt return any other data' do
    get "/api/v0/forecast?location=cincinatti,oh", headers: @headers

    expect(response).to be_successful

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result).to have_key(:data)
    expect(result[:data]).to be_a(Hash)

    # Data
    data = result[:data]

    expect(data).to have_key(:id)
    expect(data[:id]).to eq(nil)
    expect(data).to have_key(:type)
    expect(data[:type]).to eq("forecast")

    # Attributes
    expect(data).to have_key(:attributes)
    expect(data[:attributes]).to be_a(Hash)

    attributes = data[:attributes]

    # Current Weather
    expect(attributes).to have_key(:current_weather)
    expect(attributes[:current_weather]).to be_a(Hash)

    current_weather = attributes[:current_weather]

    expect(current_weather).to have_key(:last_updated)
    expect(current_weather[:last_updated]).to be_a(String)
    expect(current_weather).to have_key(:temperature)
    expect(current_weather[:temperature]).to be_a(Float)
    expect(current_weather).to have_key(:feels_like)
    expect(current_weather[:feels_like]).to be_a(Float)
    expect(current_weather).to have_key(:humidity)
    expect(current_weather[:humidity]).to be_a(Integer)
    expect(current_weather).to have_key(:uvi)
    expect(current_weather[:uvi]).to be_a(Float)
    expect(current_weather).to have_key(:visibility)
    expect(current_weather[:visibility]).to be_a(Float)
    expect(current_weather).to have_key(:condition)
    expect(current_weather[:condition]).to be_a(String)
    expect(current_weather).to have_key(:icon)
    expect(current_weather[:icon]).to be_a(String)
    expect(current_weather[:icon].include?(".png")).to eq(true)

    # Daily Weather
    expect(attributes).to have_key(:daily_weather)
    expect(attributes[:daily_weather]).to be_a(Array)
    expect(attributes[:daily_weather].length).to eq(5)

    daily_weather_days = attributes[:daily_weather]

    daily_weather_days.each do |day|
      expect(day).to be_a(Hash)
      expect(day).to have_key(:date)
      expect(day[:date]).to be_a(String)
      expect(day).to have_key(:sunrise)
      expect(day[:sunrise]).to be_a(String)
      expect(day).to have_key(:sunset)
      expect(day[:sunset]).to be_a(String)
      expect(day).to have_key(:max_temp)
      expect(day[:max_temp]).to be_a(Float)
      expect(day).to have_key(:min_temp)
      expect(day[:min_temp]).to be_a(Float)
      expect(day).to have_key(:condition)
      expect(day[:condition]).to be_a(String)
      expect(day).to have_key(:icon)
      expect(day[:icon]).to be_a(String)
      expect(day[:icon].include?(".png")).to eq(true)
    end

  # Hourly Weather
    expect(attributes).to have_key(:hourly_weather)
    expect(attributes[:hourly_weather]).to be_a(Array)

    hours = attributes[:hourly_weather]

    expect(hours.length).to eq(24)

    hours.each do |hour|
      expect(hour).to have_key(:time)
      expect(hour[:time]).to be_a(String)
      expect(hour).to have_key(:temperature)
      expect(hour[:temperature]).to be_a(Float)
      expect(hour).to have_key(:condition)
      expect(hour[:condition]).to be_a(String)
      expect(hour).to have_key(:icon)
      expect(hour[:icon]).to be_a(String)
      expect(hour[:icon].include?(".png")).to eq(true)
    end
  end
end
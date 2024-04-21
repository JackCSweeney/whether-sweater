require 'rails_helper'

RSpec.describe 'Request for Forecast by City' do
  before(:each) do
    @headers = {"CONTENT_TYPE" => "application/json"}
  end

  it 'returns the forecast for the given city in the correct format and doesnt return any other data' do
    get "/api/v0/forecast?location=cincinatti,oh", headers: @headers

    expect(response).to be_successful

    response = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_key(:data)
    expect(response[:data]).to be_a(Hash)

    # Data
    data = response[:data]

    expect(data).to have_key(:id)
    expect(data[:id]).to eq(nil)

    expect(data).to have_key(:type)
    expect(data).to eq("forecast")

    # Attributes
    expect(data).to have_key(:attributes)
    expect(data[:attributes]).to be_a(Hash)

    attributes = data[:attributes]

    # Current Weather
    expect(attributes).to have_key(:current_weather)
    expect(attributes[:current_weather]).to be_a(Hash)

    current_weather = attributes[:current_weather]

    expect(current_weather).to have_key(:last_updated)
    expect(current_weather[:last_updated]).to eq("place holder date")

    expect(current_weather).to have_key(:temperature)
    expect(current_weather[:temperature]).to be_a(Float) # Should be temp in farenheit

    expect(current_weather).to have_key(:feels_like)
    expect(current_weather[:feels_like]).to be_a(Float) # Should be temp in farenheit

    expect(current_weather).to have_key(:humidity)
    expect(current_weather[:humidity]).to be_a(Float)

    expect(current_weather).to have_key(:uvi)
    expect(current_weather[:uvi]).to be_a(Float)

    expect(current_weather).to have_key(:visibility)
    expect(current_weather[:visibility]).to be_a(Float)

    expect(current_weather).to have_key(:conditions)
    expect(current_weather[:conditions]).to be_a(String)

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
      expect(day).to have_key(:conditions)
      expect(day[:conditions]).to be_a(String)
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
      expect(hour).to have_key(:conditions)
      expect(hour[:conditions]).to be_a(String)
      expect(hour).to have_key(:icon)
      expect(hour[:icon]).to be_a(String)
      expect(hour[:icon].include?(".png")).to eq(true)
    end
  end
end
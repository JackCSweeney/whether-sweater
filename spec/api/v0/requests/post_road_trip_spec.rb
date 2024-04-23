require 'rails_helper'

RSpec.describe 'Can Create a New Road Trip and Receive Data' do
  before(:each) do
    @user = User.create!({email: "test@email.com", password: "password", password_confirmation: "password"})
    @api_key = @user.api_key
    @headers = {"CONTENT_TYPE" => "application/json"}
    @body = {origin: "cincinatti,oh", destination: "chicago,il", api_key: @api_key}
    @origin_coords = "39.10713,-84.50413"
    @dest_coords = "41.88425,-87.63245"
    @origin = "cincinatti,oh"
    @destination = "chicago,il"

    json_response = File.read("spec/fixtures/geocoding/cincinatti_oh_geocode_response.json")
    stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{Rails.application.credentials.map_quest_key}&location=#{@origin}")
      .to_return(status: 200, body: json_response)
  
    json_response = File.read("spec/fixtures/geocoding/chicago_il_get_request.json")
    stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{Rails.application.credentials.map_quest_key}&location=#{@destination}")
      .to_return(status: 200, body: json_response)

    json_response = File.read("spec/fixtures/directions/oh_to_il_directions.json")
    stub_request(:get, "https://www.mapquestapi.com/directions/v2/route?from=#{@origin_coords}&to=#{@dest_coords}&key=#{Rails.application.credentials.map_quest_key}")
      .to_return(status: 200, body: json_response)

    json_response = File.read("spec/fixtures/weather/chicago_il_weather_request.json")
    stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?key=#{Rails.application.credentials.weather_api}&q=#{@dest_coords}&days=5&aqi=no&alerts=no")
      .to_return(status: 200, body: json_response)
  end

  describe '#happy path' do
    it 'returns weather data from the destination city from the time arrival is expected' do
      post "/api/v0/road_trip", headers: @headers, params: JSON.generate(@body)

      expect(response).to be_successful
      expect(response.status).to eq(201)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to have_key(:data)
      expect(result[:data]).to be_a(Hash)

      data = result[:data]

      expect(data).to have_key(:id)
      expect(data[:id]).to eq(nil)
      expect(data).to have_key(:type)
      expect(data[:type]).to eq("road_trip")
      expect(data).to have_key(:attributes)
      expect(data[:attributes]).to be_a(Hash)

      attributes = data[:attributes]

      expect(attributes).to have_key(:start_city)
      expect(attributes[:start_city]).to be_a(String)
      expect(attributes).to have_key(:end_city)
      expect(attributes[:end_city]).to be_a(String)
      expect(attributes).to have_key(:travel_time)
      expect(attributes[:travel_time]).to be_a(String)
      expect(attributes).to have_key(:weather_at_eta)
      expect(attributes[:weather_at_eta]).to be_a(Hash)

      weather = attributes[:weather_at_eta]

      expect(weather).to have_key(:datetime)
      expect(weather[:datetime]).to be_a(String)
      expect(weather).to have_key(:temperature)
      expect(weather[:temperature]).to be_a(Float)
      expect(weather).to have_key(:condition)
      expect(weather[:condition]).to be_a(String)
    end
  end

  describe '#sad path' do
    it 'will return a 401 unauthorized error if no/incorrect api key is sent' do

    end

    it 'will not return weather at eta if travel by car is not possible' do

    end
  end
end
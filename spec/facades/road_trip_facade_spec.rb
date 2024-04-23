require 'rails_helper'

RSpec.describe RoadTripFacade do
  before(:each) do
    @facade = RoadTripFacade
    @origin = "cincinatti,oh"
    @destination = "chicago,il"
    @origin_coords = "39.10713,-84.50413"
    @dest_coords = "41.88425,-87.63245"

    json_response = File.read("spec/fixtures/geocoding/cincinatti_oh_geocode_response.json")
    stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{Rails.application.credentials.map_quest_key}&location=#{@origin}")
      .to_return(status: 200, body: json_response)
  
    json_response = File.read("spec/fixtures/geocoding/chicago_il_get_request.json")
    stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{Rails.application.credentials.map_quest_key}&location=#{@destination}")
      .to_return(status: 200, body: json_response)

    json_response = File.read("spec/fixtures/directions/oh_to_il_directions.json")
    stub_request(:get, "https://www.mapquestapi.com/directions/v2/route?from=39.10713,-84.50413&to=41.88425,-87.63245&key=#{Rails.application.credentials.map_quest_key}")
      .to_return(status: 200, body: json_response)

    json_response = File.read("spec/fixtures/weather/chicago_il_weather_request.json")
    stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?key=#{Rails.application.credentials.weather_api}&q=#{@dest_coords}&days=5&aqi=no&alerts=no")
      .to_return(status: 200, body: json_response)
  end

  describe '.class methods' do
    describe '.get_directions(origin_coords, dest_coords)' do
      it 'returns directions info' do
        data = @facade.get_directions(@origin_coords, @dest_coords)

        expect(data).to have_key(:route)
        expect(data[:route]).to be_a(Hash)
        
        route = data[:route]

        expect(route).to have_key(:formattedTime)
        expect(route[:formattedTime]).to be_a(String)
        expect(route).to have_key(:time)
        expect(route[:time]).to be_a(Integer)
        expect(route).not_to have_key(:routeError) 
      end
    end

    describe '.create_road_trip(origin_coords, dest_coords)' do
      it 'creates a road trip object from the given data' do
        expect(@facade.create_road_trip(@origin_coords, @dest_coords, @origin, @destination)).to be_a(RoadTrip)
      end
    end

    describe 'get_road_trip(params)' do
      it 'gets the road trip object from the params passed in' do
        params = {origin: @origin, destination: @destination, origin: @origin, destination: @destination}

        expect(@facade.get_road_trip(params)).to be_a(RoadTrip)
      end
    end
  end
end
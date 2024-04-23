require 'rails_helper'

RSpec.describe MapQuestFacade do
  before(:each) do
    @facade = MapQuestFacade
    @location = "cincinatti,oh"
    @origin_coords = "39.10713,-84.50413"
    @dest_coords = "41.88425,-87.63245"

    json_response = File.read("spec/fixtures/geocoding/cincinatti_oh_geocode_response.json")
    stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{Rails.application.credentials.map_quest_key}&location=#{@location}")
      .to_return(status: 200, body: json_response)
    
    json_response = File.read("spec/fixtures/geocoding/chicago_il_get_request.json")
    stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{Rails.application.credentials.map_quest_key}&location=chicago,IL")
      .to_return(status: 200, body: json_response)

    json_response = File.read("spec/fixtures/directions/oh_to_il_directions.json")
    stub_request(:get, "https://www.mapquestapi.com/directions/v2/route?from=39.10713,-84.50413&to=41.88425,-87.63245&key=#{Rails.application.credentials.map_quest_key}")
      .to_return(status: 200, body: json_response)
  end

  describe '.class methods' do
    describe '.parse_for_coords(response)' do
      it 'parses the coordinates from the given response from mapquest service' do
        response = MapQuestService.get_coords(@location)

        expect(@facade.parse_for_coords(response)).to eq("39.10713,-84.50413")
      end
    end

    describe '.get_coords(city_state)' do
      it 'returns a string of coordinates from the given city_state combo' do
        expect(@facade.get_coords(@location)).to eq("39.10713,-84.50413")
      end
    end

    describe '.get_directions(origin_coords, dest_coords)' do
      it 'returns parsed JSON data about the directions for the given coords' do
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
  end
end
require 'rails_helper'

RSpec.describe MapQuestFacade do
  before(:each) do
    @facade = MapQuestFacade
    @location = "cincinatti,oh"

    json_response = File.read("spec/fixtures/geocoding/cincinatti_oh_geocode_response.json")

    stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{Rails.application.credentials.map_quest_key}&location=#{@location}")
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
  end
end
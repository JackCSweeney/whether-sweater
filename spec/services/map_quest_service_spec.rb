require 'rails_helper'

RSpec.describe MapQuestService do
  before(:each) do
    @service = MapQuestService
    @location = "cincinatti,oh"

    json_response = File.read("spec/fixtures/geocoding/cincinatti_oh_geocode_response.json")

    stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{Rails.application.credentials.map_quest_key}&location=cincinatti,oh")
      .to_return(status: 200, body: json_response)
  end

  describe '.class methods' do
    describe '.conn' do
      it 'establishes a faraday connection' do
        expect(@service.conn).to be_a(Faraday::Connection)
      end
    end

    describe '.get_url(city_state)' do
      it 'returns a successful json response of the coordinates for the given city state combination' do
        response = @service.get_url(@location)
        
        data = JSON.parse(response.body, symbolize_names: true)
        
        expect(data).to have_key(:results)
        expect(data[:results]).to be_a(Array)
        expect(data[:results].first).to have_key(:locations)
        expect(data[:results].first[:locations].first).to have_key(:latLng)
        expect(data[:results].first[:locations].first[:latLng]).to be_a(Hash)
        expect(data[:results].first[:locations].first[:latLng]).to have_key(:lat)
        expect(data[:results].first[:locations].first[:latLng]).to have_key(:lng)
      end
    end

    describe '.get_coords(city_state)' do
      it 'parses the json response and returns the data from the http request for the given city state combo' do
        data = @service.get_coords(@location)

        expect(data).to have_key(:results)
        expect(data[:results]).to be_a(Array)
        expect(data[:results].first).to have_key(:locations)
        expect(data[:results].first[:locations].first).to have_key(:latLng)
        expect(data[:results].first[:locations].first[:latLng]).to be_a(Hash)
        expect(data[:results].first[:locations].first[:latLng]).to have_key(:lat)
        expect(data[:results].first[:locations].first[:latLng][:lat]).to be_a(Float)
        expect(data[:results].first[:locations].first[:latLng]).to have_key(:lng)
        expect(data[:results].first[:locations].first[:latLng][:lng]).to be_a(Float)
      end
    end
  end
end
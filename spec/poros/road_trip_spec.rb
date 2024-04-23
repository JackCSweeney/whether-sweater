require 'rails_helper'

RSpec.describe RoadTrip do
  before(:each) do
    directions = File.read("spec/fixtures/directions/oh_to_il_directions.json")
    directions = JSON.parse(directions, symbolize_names: true)

    forecast = File.read("spec/fixtures/weather/chicago_il_weather_request.json")
    @forecast = JSON.parse(forecast, symbolize_names: true)

    road_trip_data = {directions: directions, forecast: @forecast, origin: "Cincinatti,OH", destination: "Chicago,IL"}

    @road_trip = RoadTrip.new(road_trip_data)

    allow(Time).to receive(:now).and_return(Time.new("2024-04-22 18:48:36.492178 -0700"))
  end

  describe 'initialize' do
    it 'exists' do
      expect(@road_trip).to be_a(RoadTrip)
    end

    it 'has attributes' do
      expect(@road_trip.start_city).to eq("Cincinatti,OH")
      expect(@road_trip.end_city).to eq("Chicago,IL")
      expect(@road_trip.travel_time).to eq("04:20:40")
      expect(@road_trip.weather_at_eta).to be_a(Hash)
    end
  end

  describe '#instance methods' do
    describe '#get_dest_weather(forecast)' do
      it 'creates a hash with the appropriate data' do
        expect(@road_trip.get_dest_weather(@forecast)).to eq({datetime: "2024-04-22 23:09", temperature: 54.4, condition: "Clear "})
      end
    end
  end
end
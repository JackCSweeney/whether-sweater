require 'rails_helper'

RSpec.describe BookForecastSerializer do
  before(:each) do
    @serializer = BookForecastSerializer
    @coords = "39.74001,-104.99202"

    json_response = File.read("spec/fixtures/book_search/colorado_book_search.json")

    stub_request(:get, "https://openlibrary.org/search.json?q=denver,co")
      .to_return(status: 200, body: json_response)

    json_response = File.read("spec/fixtures/weather/denver_co_weather_request.json")

    stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?key=#{Rails.application.credentials.weather_api}&q=#{@coords}&days=5&aqi=no&alerts=no")
      .to_return(status: 200, body: json_response)

    @forecast = ForecastSerializer.serialize(ForecastFacade.get_forecast(@coords))
    @books = BookFacade.get_and_make_books("denver,co", 5)
  end

  describe '.class methods' do
    describe '.serialize' do
      it 'returns all info in the correct format' do
        info = @serializer.serialize(@forecast, @books, "denver,co")

        expect(info).to have_key(:data)
        expect(info[:data]).to be_a(Hash)
  
        data = info[:data]
  
        expect(data).to have_key(:id)
        expect(data[:id]).to eq(nil)
  
        expect(data).to have_key(:type)
        expect(data[:type]).to eq("books")
  
        expect(data).to have_key(:attributes)
        expect(data[:attributes]).to be_a(Hash)
  
        attributes = data[:attributes]
  
        expect(attributes).to have_key(:destination)
        expect(attributes[:destination]).to be_a(String)
  
        expect(attributes).to have_key(:forecast)
        expect(attributes[:forecast]).to be_a(Hash)
        expect(attributes[:forecast]).to have_key(:summary)
        expect(attributes[:forecast][:summary]).to be_a(String)
        expect(attributes[:forecast]).to have_key(:temperature)
        expect(attributes[:forecast][:temperature]).to be_a(String)
  
        expect(attributes).to have_key(:total_books_found)
        expect(attributes[:total_books_found]).to be_a(Integer)
  
        expect(attributes).to have_key(:books)
        expect(attributes[:books]).to be_a(Array)
  
        books = attributes[:books]
        expect(books.length).to eq(5)
  
        books.each do |book|
          expect(book).to be_a(Hash)
          expect(book).to have_key(:isbn)
          expect(book[:isbn]).to be_a(Array)
          expect(book[:isbn].all?(String)).to eq(true)
          expect(book).to have_key(:title)
          expect(book[:title]).to be_a(String)
          expect(book).to have_key(:publisher)
          expect(book[:publisher]).to be_a(Array)
          expect(book[:publisher].all?(String)).to eq(true)
        end
      end
    end

    describe '.book_data(books)' do
      it 'creates an array of hashes with book data' do
        result = BookForecastSerializer.book_data(@books.last)

        expect(result).to be_a(Array)
        expect(result.all?(Hash)).to eq(true)
        expect(result.count).to eq(5)
        result.each do |book|
          expect(book).to have_key(:isbn)
          expect(book[:isbn]).to be_a(Array)
          expect(book).to have_key(:title)
          expect(book[:title]).to be_a(String)
          expect(book).to have_key(:publisher)
          expect(book[:publisher]).to be_a(Array)
        end
      end
    end
  end
end
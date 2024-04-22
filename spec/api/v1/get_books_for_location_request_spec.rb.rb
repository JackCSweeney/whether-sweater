require 'rails_helper'

RSpec.describe 'Get Books for Location Request' do
  before(:each) do
    @headers = {"CONTENT_TYPE" => "application/json"}
  end

  describe 'happy path' do
    it 'returns the forecast for the given city and a list of books about the city along with the location city' do
      get "/api/v1/book-search?location=denver,co&quantity=5", headers: @headers

      expect(response).to be_successful

      info = JSON.parse(response.body, symbolize_names: true)

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

  describe 'sad path' do
    it '' do

    end
  end
end
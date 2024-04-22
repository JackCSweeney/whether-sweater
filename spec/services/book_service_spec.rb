require 'rails_helper'

RSpec.describe BookService do
  before(:each) do
    @service = BookService

    json_response = File.read("spec/fixtures/book_search/colorado_book_search.json")
    stub_request(:get, "https://openlibrary.org/search.json?q=denver,co")
      .to_return(status: 200, body: json_response)
  end

  describe '.class methods' do
    describe '.conn' do
      it 'creates a faraday connection' do
        expect(@service.conn).to be_a(Faraday::Connection)
      end
    end

    describe '.get_url(url)' do
      it 'returns a faraday response that can be json parsed' do
        result = @service.get_url("denver,co")

        expect(result).to be_a(Faraday::Response)

        data = JSON.parse(result.body, symbolize_names: true)
        expect(data).to be_a(Hash)
      end
    end

    describe '.get_books(location)' do
      it 'returns the correct parsed data for books based on the given locaiton' do
        response = @service.get_books("denver,co")

        expect(response).to be_a(Hash)

        expect(response).to have_key(:numFound)
        expect(response[:numFound]).to be_a(Integer)
        expect(response).to have_key(:docs)
        expect(response[:docs]).to be_a(Array)

        books = response[:docs]

        books.each do |book|
          expect(book).to have_key(:title)
          expect(book[:title]).to be_a(String)
          if book[:isbn]
            expect(book[:isbn]).to be_a(Array)
            expect(book[:isbn].all?(String)).to eq(true)
          end
          if book[:publisher]
            expect(book[:publisher]).to be_a(Array)
            expect(book[:publisher].all?(String)).to eq(true)
          else
            expect(book).to have_key(:contributor)
            expect(book[:contributor]).to be_a(Array)
            expect(book[:contributor].all?(String)).to eq(true)
          end
        end
      end
    end
  end
end
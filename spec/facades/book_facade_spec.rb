require 'rails_helper'

RSpec.describe BookFacade do
  before(:each) do
    @facade = BookFacade

    json_response = File.read("spec/fixtures/book_search/colorado_book_search.json")
    stub_request(:get, "https://openlibrary.org/search.json?q=denver,co")
      .to_return(status: 200, body: json_response)
  end

  describe '.class methods' do
    describe '.get_books(location, quantity)' do
      it 'returns data with books about the given location' do
        response = @facade.get_books("denver,co")

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
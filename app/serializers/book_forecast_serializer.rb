class BookForecastSerializer
  def self.serialize(forecast, books, location)
    {
      data: {
        id: nil,
        type: "books",
        attributes: {
          destination: location,
          forecast: {
            summary: forecast[:data][:attributes][:current_weather][:condition],
            temperature: "#{forecast[:data][:attributes][:current_weather][:temperature]} F"
          },
          total_books_found: books.first,
          books: book_data(books.last)
        }
      }
    }
  end

  def self.book_data(books)
    books.map do |book|
      {
        isbn: book.isbn,
        title: book.title,
        publisher: book.publisher
      }
    end
  end
end
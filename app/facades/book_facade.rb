class BookFacade
  def self.get_books(location)
    books_info = BookService.get_books(location)
  end

  def self.make_books(books_info, quantity)
    books = books_info[:docs]
    books.slice(0, quantity.to_i).map do |book_info|
      Book.new(book_info)
    end
  end

  def self.get_and_make_books(location, quantity)
    books_info = get_books(location)
    books = make_books(books_info, quantity)
    [books_info[:numFound], books]
  end
end
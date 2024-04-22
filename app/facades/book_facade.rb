class BookFacade
  def self.get_books(location)
    BookService.get_books(location)
  end
end
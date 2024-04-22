class BookService
  def self.conn 
    Faraday.new("https://openlibrary.org")
  end

  def self.get_url(location)
    conn.get("/search.json?q=#{location}")
  end

  def self.get_books(location)
    response = get_url(location)
    JSON.parse(response.body, symbolize_names: true)
  end
end

class Book
  attr_reader :isbn, :title, :publisher

  def initialize(attributes)
    @isbn = attributes[:isbn]
    @title = attributes[:title]
    @publisher = attributes[:publisher]
  end
end
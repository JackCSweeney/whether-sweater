require 'rails_helper'

RSpec.describe Book do
  before(:each) do
    @info = {
      key: "/works/OL4437736W",
      type: "work",
      seed: [
          "/books/OL10911511M",
          "/works/OL4437736W",
          "/authors/OL882946A"
      ],
      title: "Denver Co Deluxe Flip Map",
      title_suggest: "Denver Co Deluxe Flip Map",
      title_sort: "Denver Co Deluxe Flip Map",
      edition_count: 1,
      edition_key: [
          "OL10911511M"
      ],
      publish_date: [
          "January 2003"
      ],
      publish_year: [
          2003
      ],
      first_publish_year: 2003,
      isbn: [
          "0762557362",
          "9780762557363"
      ],
      last_modified_i: 1260838560,
      ebook_count_i: 0,
      ebook_access: "no_ebook",
      has_fulltext: false,
      public_scan_b: false,
      publisher: [
          "Universal Map Enterprises"
      ],
      language: [
          "eng"
      ],
      author_key: [
          "OL882946A"
      ],
      author_name: [
          "Laura Ryder"
      ],
      publisher_facet: [
          "Universal Map Enterprises"
      ],
      _version_: 1767935634853330944,
      author_facet: [
          "OL882946A Laura Ryder"
      ]
    }
  end

  describe 'Initialize' do
    it 'exists' do
      book = Book.new(@info)

      expect(book).to be_a(Book)
    end
  end

  describe 'attributes' do
    it 'has all the needed attributes' do
      book = Book.new(@info)

      expect(book.isbn).to eq(["0762557362","9780762557363"])
      expect(book.title).to eq("Denver Co Deluxe Flip Map")
      expect(book.publisher).to eq(["Universal Map Enterprises"])
    end
  end
end
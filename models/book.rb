class Book
  attr_reader :author,
              :title,
              :genre,
              :published_on,
              :upvoters,
              :recommendations

  def initialize(author, title, genre, published_on)
    @author = author
    @title = title
    @genre = genre
    @published_on = published_on
    @upvoters = []
    @author.books << self
  end

  def to_s
    @title
  end
end

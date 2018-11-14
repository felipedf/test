class Book
  attr_reader :author, :title, :published_on, :upvoters, :recommendations

  def initialize(author, title, published_on)
    @author = author
    @title = title
    @published_on = published_on
    @upvoters = []
    @recommendations = 0
    @author.books << self
  end
end
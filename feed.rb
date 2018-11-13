require 'pqueue'

class Feed
  def initialize(user)
    @user = user
  end

  def retrieve
    relevant_authors = classify_authors

    books = fetch_books(relevant_authors)
    classify_books(books, relevant_authors)
    feed_queue = PQueue.new(books)
  end

  def refresh
    # TODO: need more details about this.
  end

  private

  def classify_authors
    authors = @user.upvoted_books.each_with_object({}) do |book, hash|
      author = book.author
      hash[author] = (hash[author] || 0) + 0.1
    end
    @user.following.each do |author|
      authors[author] = (authors[author] || 0) + 0.15
    end

    authors
  end

  def classify_books(books, authors)
    books.each do |book|
      #TODO
    end
  end

  # Fake a book fetch from some source
  def fetch_books(relevant_authors)
    # Adding some random authors so we may have some books that weren't authored
    # by any author related to this particular user.
    authors = DataSeeder.create_authors(3) + relevant_authors.keys
    DataSeeder.create_books(10, authors)
  end
end
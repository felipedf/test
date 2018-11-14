require 'fc'

class Feed
  def initialize(user)
    @user = user
    @feed_queue = FastContainers::PriorityQueue.new(:max)
  end

  def retrieve
    relevant_authors = classify_authors

    books = fetch_books(relevant_authors)
    calculate_books_priority(books, relevant_authors)

    @feed_queue.pop_each { |book, priority| puts([book, priority]) }
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

  def calculate_books_priority(books, authors)
    books.each_with_object({}) do |book, hash|
      hash[book] = 0.1
      days_old = Date.today - book.published_on
      date_coefficient = 0.20 - (days_old * 0.02)
      hash[book] += [0, date_coefficient].max
      hash[book] += authors[book.author] if authors[book.author]

      @feed_queue.push(book.title, hash[book])
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

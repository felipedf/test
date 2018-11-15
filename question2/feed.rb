require 'fc'

class Feed
  def initialize(user)
    @user = user
    @feed_queue = FastContainers::PriorityQueue.new(:max)
  end

  def retrieve
    refresh
    feed = []
    @feed_queue.pop_each {|book, _| feed << book}

    feed
  end

  def refresh
    relevant_authors = classify_authors
    books = fetch_books(5, relevant_authors)
    calculate_books_priority(books, relevant_authors)
  end

  private

  # Classify all authors somewhat related to the user, either the user has
  # upvoted the author's boook or follows the author.
  # Return a Hash, where the keys are authors and the values are the percentage
  # bonus.
  def classify_authors
    # This adds a coefficient of 0.1 that meaning that all books from a
    # a author that this particular user upvoted, will have 10% more chance
    # to appear o his feed.
    authors = @user.upvoted_books.each_with_object({}) do |book, hash|
      author = book.author
      hash[author] = (hash[author] || 0) + 0.05
    end

    # This does the same as above, but adds 15% more chance to books of an author
    # that the user follows.
    @user.following.each do |author|
      authors[author] = (authors[author] || 0) + 0.15
    end

    authors
  end

  def calculate_books_priority(books, authors = [])
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
  def fetch_books(total_new_books, relevant_authors)
    # Adding some random authors so we may have some books that weren't authored
    # by any author related to this particular user.
    authors = DataSeeder.create_authors(3) + relevant_authors.keys
    binding.pry
    DataSeeder.create_books(total_new_books, authors)
  end
end

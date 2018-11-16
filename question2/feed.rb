require 'fc'

class Feed
  def initialize(user)
    @user = user
    # Representing the feed as a priority queue, so newly added books can be
    # classified and sorted faster than a regular queue.
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
    # Fetching books that might be relevant to the user.
    books = DataSeeder.fetch_books(5, relevant_authors)
    calculate_books_priority(books, relevant_authors)
  end

  private

  # Classify all authors somewhat related to the user, either the user has
  # upvoted the author's book or follows the author.
  # Return a Hash, where the keys are authors and the values are the percentage
  # bonus.
  def classify_authors
    # This adds a coefficient of 0.1 meaning that all books from a author
    # that this particular user upvoted, will have a better chance
    # to appear o his feed.
    authors = @user.upvoted_books.each_with_object({}) do |book, hash|
      author = book.author
      hash[author] = (hash[author] || 0) + 0.05
    end

    # This does the same as above, but adds a better chance to books of an author
    # that the user follows.
    @user.following.each do |author|
      authors[author] = (authors[author] || 0) + 0.15
    end

    authors
  end

  def calculate_books_priority(books, authors = [])
    books.each_with_object({}) do |book, hash|
      # This represents a chance that any book can appear on user's feed.
      hash[book] = 0.1
      # New published books will have more chance to appear on user's feed
      days_old = Date.today - book.published_on
      # Newly published books will have a bonus that will every day
      date_coefficient = 0.20 - (days_old * 0.02)
      # The coefficient can't be negative.
      hash[book] += [0, date_coefficient].max
      # Add to the account the previously calculated coefficients based on book's authors
      hash[book] += authors[book.author] if authors[book.author]

      # This is the trick so that the books that will appear on user's feed
      # won't that predictable. books more related to the user will have a great
      # chance to appear, but from time to time the user might come across books
      # that are entirely new to him/her.
      hash[book] += rand
      @feed_queue.push(book, hash[book])
    end
  end
end

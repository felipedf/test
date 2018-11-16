class DataSeeder
  def self.create_authors(total_authors)
    authors = []
    total_authors.times { authors << Author.new(Faker::Name.name) }

    authors
  end

  def self.create_books(total_books, authors)
    books = []
    # Using +array.sample+ here to pick a random and unique author from the list.
    authors_sample = authors.sample(total_books)
    total_books.times do |n|
      books << Book.new(authors_sample[n],
                        Faker::Book.title,
                        Faker::Book.genre,
                        Faker::Date.backward)
    end

    books
  end

  # Given a user, upvote +total_times+ books
  def self.upvote_books(total_upvotes, user, books)
    # Using +array.sample+ here to pick a random book ( without repeating )
    books_sample = books.sample(total_upvotes)
    total_upvotes.times do |n|
      Upvote.compute_upvote(user, books_sample[n])
    end
  end

  def self.follow_authors(total_follows, user, authors)
    # Using +array.sample+ here to pick a random author ( without repeating )
    authors_sample = authors.sample(total_follows)
    total_follows.times do |n|
      Follow.compute_follow(user, authors_sample[n])
    end
  end

  def self.create_users(total_users)
    users = []
    total_users.times { users << User.new(Faker::Name.name) }

    users
  end

  # Fake a fetch of users with their respective relationships
  # +relevant_books+ this is a sugar, so it will be possible that different users
  # upvoted the same book.
  def self.fetch_users(total_new_users, relevant_books)
    users = self.create_users(total_new_users)
    authors = self.create_authors(40)
    books = self.create_books(30, authors) + relevant_books
    # make the users upvote different times from each other, so the result will
    # be less biased.
    users.each {|user| self.upvote_books(rand(10...30) ,user, books) }
  end

  # Fake a book fetch from some source (database)
  # +relevant_books+ this is a sugar, so it can fetch books that might be
  # related to the user somehow.
  def self.fetch_books(total_new_books, relevant_authors = {})
    # Adding some random authors so we may have some books that weren't authored
    # by any author related to this particular user.
    authors = self.create_authors(total_new_books) + relevant_authors.keys
    self.create_books(total_new_books, authors)
  end
end

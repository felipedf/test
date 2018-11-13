class DataSeeder
  def self.create_authors(total_authors)
    authors = []
    total_authors.times { authors << Author.new(Faker::Name.name) }

    authors
  end

  def self.create_books(total_books, authors)
    books = []
    # Using +array.sample+ here to pick a random author from the list.
    total_books.times { books << Book.new(authors.sample, Faker::Book.title, Faker::Date.backward)}

    books
  end

  # Given a user, upvote +total_times+ books
  def self.upvote_books(total_upvotes, user, books)
    total_upvotes.times do
      # Using +array.sample+ here to pick a random book ( without repeating )
      Upvote.compute_upvote(user, books.sample)
    end
  end

  def self.follow_authors(total_follows, user, authors)
    total_follows.times do
      # Using +array.sample+ here to pick a random author ( without repeating )
      Follow.compute_follow(user, authors.sample)
    end
  end
end

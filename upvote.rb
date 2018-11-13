class Upvote
  class << self
    def compute_upvote(user, book)
      user.upvoted_books << book
      book.upvoters << user
    end
  end
end

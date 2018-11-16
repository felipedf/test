module Recommendation
  def recommend_books_based_on_genre
    # find candidate books to be evaluated for recommendation
    other_books = DataSeeder.fetch_books(10)
    # instantiate a new hash, set default value for any keys to 0
    recommended = Hash.new(0)

    # set a weight for each genre based on the user's upvoted_books
    genre_preference_score = self.upvoted_books.each_with_object({}) do |book, hash|
      hash[book.genre] = (hash[book.genre] || 0) + 1
    end
    # for each user of all other users
    other_books.each do |book|
      # don't bother evaluating a book that the user has already upvoted.
      next if self.upvoted_books.map(&:title).include?(book.title)
      # the weight of this book will be set based on the user's genre_preference_score
      recommended[book] = genre_preference_score[book.genre] || 0
    end
    #Array[Array[book.tittle, weight]]: sort by weight in descending order
    recommended.sort_by { |key, value| value }.reverse
  end

  def recommended_books_collaborative_filtering(users_sample = nil)
      # find all other users
      other_users = users_sample || DataSeeder.fetch_users(10, self.upvoted_books[0..20])
      # instantiate a new hash, set default value for any keys to 0
      recommended = Hash.new(0)
      # for each user of all other users
      other_users.each do |user|
        # find the books this user and another user both upvoted
        common_books = user.upvoted_books.map(&:title) & self.upvoted_books.map(&:title)
        # calculate the weight (recommendation rating)
        weight = common_books.length.to_f / user.upvoted_books.length
        # add the extra books the other user liked
        user.upvoted_books.each do |book|
          # common_books contain all common title between 2 users, so we don't
          # want to recommend a book that the current user has already upvoted.
          next if common_books.include?(book.title);
          # put the book along with the cumulative weight into hash
          recommended[book] += weight
        end
      end
      # sort by weight in descending order
      recommended.sort_by { |key, value| value }.reverse
  end
end

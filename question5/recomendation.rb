module Recommendation
  def recommend_books # recommend books to a user
    # find all other users
    other_users = DataSeeder.create_users(10)
    # instantiate a new hash, set default value for any keys to 0
    recommended = Hash.new(0)
    # for each user of all other users
    other_users.each do |user|
      # find the books this user and another user both upvoted
      common_books = user.upvoted_books & self.upvoted_books
      # calculate the weight (recommendation rating)
      weight = common_books.length.to_f / user.upvoted.length
      # add the extra books the other user liked
      (user.upvoted_books - common_books).each do |book|
        # put the book along with the cumulative weight into hash
        recommended[book] += weight
      end
    end
    # sort by weight in descending order
    recommended.sort_by { |key, value| value }.reverse
  end
end
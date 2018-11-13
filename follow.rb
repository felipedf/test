class Follow
  class << self
    def compute_follow(user, author)
      user.following << author
      author.followers << user
    end
  end
end
class User
  attr_reader :name, :upvoted_books, :following
  def initialize(name)
    @name = name
    @upvoted_books = []
    @following = []
  end
end

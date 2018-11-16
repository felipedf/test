require_relative '../question5/recommendation'

class User
  include Recommendation
  attr_reader :name, :upvoted_books, :following
  def initialize(name)
    @name = name
    @upvoted_books = []
    @following = []
  end
end

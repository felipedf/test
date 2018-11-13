class Author
  attr_reader :name, :followers
  attr_accessor :books

  def initialize(name)
    @name = name
    @followers = []
    @books = []
  end
end
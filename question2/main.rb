require 'faker'
%w[question2/feed models/user models/book models/upvote models/author models/follow lib/data_seeder].each do |req_class|
  require_relative "../#{req_class}"
end

class Seeding
  def self.seed
    user = User.new(Faker::Name.name)
    authors = DataSeeder.create_authors(10)
    books = DataSeeder.create_books(5, authors)
    DataSeeder.upvote_books(3 ,user, books)
    DataSeeder.follow_authors(5, user, authors)

    user
  end
end

feed = Feed.new(Seeding.seed)
p "#==========================BEFORE REFRESH=================================#"
puts feed.retrieve
p "#==========================AFTER REFRESH=================================#"
# This is brand new feed, won't consider the previous one
feed.refresh
puts feed.retrieve

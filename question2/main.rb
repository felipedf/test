require 'faker'
require 'pry-nav'
require 'pry'
%w[feed user book upvote author follow lib/data_seeder].each do |req_class|
  require_relative req_class
end

class Seeding
  def self.seed
    user = User.new(Faker::Name.name)
    authors = DataSeeder.create_authors(3)
    books = DataSeeder.create_books(5, authors)
    DataSeeder.upvote_books(3 ,user, books)
    DataSeeder.follow_authors(2, user, authors)

    user
  end
end

feed = Feed.new(Seeding.seed)
p feed.retrieve
p "#======================================================#"
feed.refresh
p feed.retrieve

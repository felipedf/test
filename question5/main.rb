require 'faker'
%w[models/user models/book models/upvote models/author lib/data_seeder].each do |req_class|
  require_relative "../#{req_class}"
end

class Seeding
  def self.seed
    # Need a bigger data so the result will be more relevant
    user = User.new(Faker::Name.name)
    authors = DataSeeder.create_authors(90)
    books = DataSeeder.create_books(60, authors)
    DataSeeder.upvote_books(30 ,user, books)

    user
  end
end

user = Seeding.seed

puts "#============================Filtering Based on Genre==========================================#"
# Print all recommended books based on user's upvoted books's genre
puts user.recommend_books_based_on_genre
puts "#=============================Collaborative Filtering==========================================#"
# Print all recommended books based on upvotes of other users
puts user.recommended_books_collaborative_filtering

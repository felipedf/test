require 'rspec/collection_matchers'
require 'faker'
%w[question2/feed models/user models/book models/upvote models/author models/follow lib/data_seeder].each do |req_class|
  require_relative "../#{req_class}"
end

describe Recommendation do
  before do
    @user = User.new(Faker::Name.name)
    authors = DataSeeder.create_authors(90)
    books = DataSeeder.create_books(60, authors)
    DataSeeder.upvote_books(35 ,@user, books)
  end

  describe "#recommend_books_based_on_genre" do
    it "returns a recommended list of books based on genre" do
      recommended_list = @user.recommend_books_based_on_genre

      # Array with genres of all books upvoted by the user
      map_of_genres = @user.upvoted_books.map(&:genre)
      user_prefered_genres = map_of_genres.each_with_object({}) do |genre, hash|
         hash[genre] = (hash[genre] || 0) + 1
      end

      most_recommended_book_score = recommended_list[0][1]
      second_most_recommended_book_score = recommended_list[1][1]

      expect(most_recommended_book_score).to be >= second_most_recommended_book_score
    end
  end

  describe "#recommended_books_collaborative_filtering" do
    it "returns a recommended list of books based on other users upvotes" do
      upvoted_books_sample = @user.upvoted_books[1..10]
      new_user = User.new(Faker::Name.name)
      authors = DataSeeder.create_authors(15)
      books = DataSeeder.create_books(10, authors)
      # 3 books so we can guarantee that this new user will at least upvote a
      # book that the current user upvoted, and one book that the current user
      # didn't upvoted.
      DataSeeder.upvote_books(15 ,new_user, books + upvoted_books_sample)

      # Recommended list of books bases on upvotes of +new_user+
      recommended_list = @user.recommended_books_collaborative_filtering([new_user])
      # All book titles on the +recommended_list+
      books_title = recommended_list.map {|book_and_weigth| book_and_weigth[0].title}
      # titles that the current user upvoted
      current_user_books = @user.upvoted_books.map(&:title)

      expect(current_user_books & books_title).to eq([])
      expect(recommended_list.length).to be > 0
      # The book weigth to be > 0
      expect(recommended_list[0][1]).to be > 0
    end
  end
end

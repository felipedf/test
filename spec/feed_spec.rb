require 'rspec/collection_matchers'
require 'faker'
%w[question2/feed models/user models/book models/upvote models/author models/follow lib/data_seeder].each do |req_class|
  require_relative "../#{req_class}"
end

describe Feed do
  before do
    @user = User.new(Faker::Name.name)
    @authors = DataSeeder.create_authors(8)
    @books = DataSeeder.create_books(5, @authors)
    DataSeeder.upvote_books(3 ,@user, @books)
    DataSeeder.follow_authors(3, @user, @authors)
    @feed = Feed.new(@user)
  end

  describe "#retrieve" do
    it "returns a prioritized array of books" do
      feed_list = @feed.retrieve
      # The feed_list will have books authored by authors related to the user
      expect(feed_list.map(&:author) & @authors).to have_at_least(1).items
      expect(feed_list).to have_at_most(5).items
    end
  end

  describe "#refresh" do
    it "Adds more books to the user's feed" do
      feed_before_refresh = @feed.retrieve.size
      @feed.refresh
      feed_after_refresh = @feed.retrieve.size
      expect(feed_after_refresh).to be > feed_before_refresh
    end
  end
end

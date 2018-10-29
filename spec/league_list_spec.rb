require "spec_helper"

RSpec.describe LeagueList do
  complete_hash_array = Scraper::LeagueList.scrape
  complete_list = LeagueList.new(complete_hash_array)

  it "orders leagues alphabetically by name" do
    name_array = complete_list.leagues.flatten.map(&:name)
    expect(name_array).to eq(name_array.sort)
  end

  xit "#find_by_country returns a new LeagueList of all leagues in a " \
    "specific country" do end

  xit "#search_by_name returns a new LeagueList of countries whose name  " \
    "matches the supplied string, ignoring case" do end

  xit "#search_by_location returns a new LeagueList of countries whose city  " \
    " or country matches the supplied string, ignoring case" do end
end

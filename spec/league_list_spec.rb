require "spec_helper"

RSpec.describe LeagueList do
  let(:complete_list) { LeagueList.new(Scraper::LeagueList.scrape).pages }
  let(:name_array) { complete_list.flatten.map(&:name) }

  it "orders leagues alphabetically by name" do
    expect(name_array).to eq(name_array.sort)
  end

  xit "#find_by_country returns a new LeagueList of all leagues in a " \
    "specific country" do end

  xit "#search_by_name returns a new LeagueList of countries whose name  " \
    "matches the supplied string, ignoring case" do end

  xit "#search_by_location returns a new LeagueList of countries whose city  " \
    " or country matches the supplied string, ignoring case" do end
end

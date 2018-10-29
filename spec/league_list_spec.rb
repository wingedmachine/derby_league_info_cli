require "spec_helper"

RSpec.describe LeagueList do
  complete_hash_array = Scraper::LeagueList.scrape
  complete_list = LeagueList.new(complete_hash_array)

  it "has attr_readers for curr_page and total_pages" do
    expect(complete_list).to respond_to(:curr_page, :total_pages)
  end

  it "orders leagues alphabetically by name" do
    name_array = complete_list.flatten.map(&:name)
    expect(name_array).to eq(name_array.sort)
  end

  it "divides the list into 10 league pages" do
    expect(complete_list[0..-2].map(&:size) == 10).to all( be_true )
    expect(complete_list.last.size).to be <= 10
  end

  it "#next_page returns the next page if there is one" do
    expect(false).to be_true
  end

  it "#prev_page returns the prev page if there is one" do
    expect(false).to be_true
  end

  it "#turn_to returns a specific page if it exists" do
    expect(false).to be_true
  end

  it "#find_by_country returns a new LeagueList of all leagues in a " \
    "specific country" do

    expect(false).to be_true
  end

  it "#search_by_name returns a new LeagueList of countries whose name  " \
    "matches the supplied string, ignoring case" do

    expect(false).to be_true
  end

  it "#search_by_location returns a new LeagueList of countries whose city  " \
    " or country matches the supplied string, ignoring case" do

    expect(false).to be_true
  end
end

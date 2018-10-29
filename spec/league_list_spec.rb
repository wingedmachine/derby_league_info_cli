require "spec_helper"

RSpec.describe LeagueList do
  let(:raw_north_subset) { Scraper::LeagueList.scrape( \
    "https://wftda.com/?s=north&post_type=leagues") }
  let(:north_subset) { LeagueList.create_from_hash_array(raw_north_subset) }
  let(:name_array) { north_subset.pages.flatten.map(&:name) }

  it "orders leagues alphabetically by name" do
    expect(name_array).to eq(name_array.sort)
  end

  it "#find_by_countrycode returns a new LeagueList of all leagues in a " \
    "specific country" do

    expect(north_subset.find_by_country_code("AU")).to eq(
      LeagueList.create_from_hash_array( [
        { name: "Northside Rollers",
          city: "Melbourne, VIC",
          country: "AU",
          is_full_member: true,
          profile_url: "https://wftda.com/wftda-leagues" \
            "/northside-rollers/"},
        { name: "Northern Brisbane Rollers",
          city: "Brisbane, QLD",
          country: "AU",
          is_full_member: true,
          profile_url: "https://wftda.com/wftda-leagues/" \
            "northern-brisbane-rollers/"} ] ))
  end

  it "#search_by_name returns a new LeagueList of leagues whose name  " \
    "matches the supplied string, ignoring case" do

    expect(north_subset.search_by_name("city")).to eq(
      LeagueList.create_from_hash_array( [
        { name: "Rose City Rollers",
          city: "Portland, OR",
          country: "US",
          is_full_member: true,
          profile_url: "https://wftda.com/wftda-leagues/" \
            "rose-city-rollers/"},
        { name: "Rockin City Rollergirls",
          city: "Round Rock, TX",
          country: "US",
          is_full_member: true,
          profile_url: "https://wftda.com/wftda-leagues/" \
            "rockin-city-rollergirls/"} ] ))
  end

  it "#search_by_location returns a new LeagueList of leagues whose city  " \
    " or country matches the supplied string, ignoring case" do

    expect(north_subset.search_by_location("TON")).to eq(
      LeagueList.create_from_hash_array( [
        { name: "North Texas Roller Derby",
          city: "Denton, TX",
          country: "US",
          is_full_member: true,
          profile_url: "https://wftda.com/wftda-leagues/" \
            "north-texas-roller-derby/"},
        { name: "Northwest Derby Company",
          city: "Bremerton, WA",
          country: "US",
          is_full_member: true,
          profile_url: "https://wftda.com/wftda-leagues/" \
            "northwest-derby-company/"} ] ))
    expect(north_subset.search_by_location("trALi")).to eq(
      LeagueList.create_from_hash_array( [
        { name: "Northside Rollers",
          city: "Melbourne, VIC",
          country: "AU",
          is_full_member: true,
          profile_url: "https://wftda.com/wftda-leagues" \
            "/northside-rollers/"},
        { name: "Northern Brisbane Rollers",
          city: "Brisbane, QLD",
          country: "AU",
          is_full_member: true,
          profile_url: "https://wftda.com/wftda-leagues/" \
            "northern-brisbane-rollers/"} ] ))
  end
end

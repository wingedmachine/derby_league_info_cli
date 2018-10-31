require "spec_helper"

RSpec.describe LeagueList do
  let (:australia) { Country.new("AU", "Australia") }
  let (:america) { Country.new("US", "United States of America") }
  let(:countries_in_north_subset) { CountryList.new([australia, america]) }
  let(:north_texas_roller_derby) { League.new(
    { name: "North Texas Roller Derby",
      city: "Denton, TX",
      country: "US",
      is_full_member: true,
      profile_url: "https://wftda.com/wftda-leagues/" \
        "north-texas-roller-derby/" },
      america) }
  let(:northern_brisbane_rollers) { League.new(
    { name: "Northern Brisbane Rollers",
      city: "Brisbane, QLD",
      country: "AU",
      is_full_member: true,
      profile_url: "https://wftda.com/wftda-" \
        "leagues/northern-brisbane-rollers/" },
      australia) }
  let(:northside_rollers) { League.new(
    { name: "Northside Rollers",
      city: "Melbourne, VIC",
      country: "AU",
      is_full_member: true,
      profile_url: "https://wftda.com/wftda-leagues" \
        "/northside-rollers/" },
      australia) }
  let(:northwest_derby_company) { League.new(
    { name: "Northwest Derby Company",
      city: "Bremerton, WA",
      country: "US",
      is_full_member: true,
      profile_url: "https://wftda.com/wftda-leagues/" \
        "northwest-derby-company/"},
      america) }
  let(:rockin_city_rollergirls) { League.new(
    { name: "Rockin City Rollergirls",
      city: "Round Rock, TX",
      country: "US",
      is_full_member: true,
      profile_url: "https://wftda.com/wftda-leagues/" \
        "rockin-city-rollergirls/" },
      america) }
  let(:rose_city_rollers) { League.new(
    { name: "Rose City Rollers",
      city: "Portland, OR",
      country: "US",
      is_full_member: true,
      profile_url: "https://wftda.com/wftda-leagues/" \
        "rose-city-rollers/" },
      america) }

  let(:north_subset) { LeagueList.new([north_texas_roller_derby,
                                       northside_rollers,
                                       rockin_city_rollergirls,
                                       northern_brisbane_rollers,
                                       northwest_derby_company,
                                       rose_city_rollers]) }
  let(:name_array) { north_subset.pages.flatten.map(&:name) }

  it "orders leagues alphabetically by name" do
    expect(name_array).to eq(name_array.sort)
  end

  it "#find_by_countrycode returns a new league hash array of all leagues in " \
    "a specific country" do

    allow(north_subset).to receive(:countries) \
      { countries_in_north_subset }
    expect(north_subset.find_by_country_code("AU")).to eq( \
      [northside_rollers, northern_brisbane_rollers])
  end

  it "#search_by_name returns a new LeagueList of leagues whose name  " \
    "matches the supplied string, ignoring case" do
    expect(north_subset.search_by_name("city")).to eq( \
      LeagueList.new([rose_city_rollers, rockin_city_rollergirls]) )
  end

  it "#search_by_location returns a new LeagueList of leagues whose city  " \
    " or country matches the supplied string, ignoring case" do

    allow(north_subset).to receive(:countries) \
      { countries_in_north_subset }
    expect(north_subset.search_by_location("ton")).to eq(
      LeagueList.new([north_texas_roller_derby, northwest_derby_company]) )
    expect(north_subset.search_by_location("trali")).to eq(
      LeagueList.new([northside_rollers, northern_brisbane_rollers]) )
  end
end

require "spec_helper"

RSpec.describe Scraper::LeagueList do
  let(:bomber_subset_url) { "https://wftda.com/?s=bomber&post_type=leagues" }
  let(:bomber_subset) { [
    { name: "Bradentucky Bombers Roller Derby League",
      city: "Bradenton, FL",
      country: "US",
      is_full_member: false,
      profile_url: "https://wftda.com/wftda-leagues/bradentucky-" \
        "bombers-roller-derby-league/" },
    { name: "Beet City Bombers",
      city: "Boise, ID",
      country: "US",
      is_full_member: false,
      profile_url: "https://wftda.com/wftda-leagues/beet-city-bombers/" },
    { name: "Lincolnshire Bombers Roller Derby",
      city: "Lincolnshire, England",
      country: "GB",
      is_full_member: true,
      profile_url: "https://wftda.com/wftda-leagues/lincolnshire-" \
        "bombers-roller-derby/" },
    { name: "Boulder County Bombers",
      city: "Longmont, CO",
      country: "US",
      is_full_member: true,
      profile_url: "https://wftda.com/wftda-leagues/boulder-county-" \
        "bombers/" },
    { name: "Charm City Roller Girls",
      city: "Baltimore, MD",
      country: "US",
      is_full_member: true,
      profile_url: "https://wftda.com/wftda-leagues/charm-city-roller-" \
        "girls/" }
  ] }
  let(:league_list) { Scraper::LeagueList.scrape(bomber_subset_url) }

  it "returns an array of hashes with keys for name, city, country, " \
    "membership, and profile_url" do

    expect(league_list).to be_an_instance_of(Array).and \
      all( be_an_instance_of(Hash) ).and \
      all ( have_key(:name) \
            .and have_key(:city) \
            .and have_key(:country) \
            .and have_key(:is_full_member) \
            .and have_key(:profile_url) )
  end

  it "returns correct data" do
    expect(Scraper::LeagueList.scrape( \
      bomber_subset_url)).to eq(bomber_subset)
  end
end

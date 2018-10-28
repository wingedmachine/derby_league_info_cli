require "spec_helper"

RSpec.describe "Scraper::LeagueList" do
  it "returns an array of hashes with keys for name, city, country, " \
    "membership, and profile_url" do

    league_list = DerbyLeagueInfoCli::Scraper::LeagueList.scrape
    expect(league_list).to be_an_instance_of(Array).and \
      all( be_an_instance_of(Hash) ).and \
      all ( have_key(:name) \
            .and have_key(:city) \
            .and have_key(:country) \
            .and have_key(:member?) \
            .and have_key(:profile_url) )
  end

  it "returns correct data" do
    bomber_subset_url = "https://wftda.com/?s=bomber&post_type=leagues"
    bomber_subset = [
      { name: "Bradentucky Bombers Roller Derby League",
        city: "Bradenton, FL",
        country: "US",
        member?: false,
        profile_url: "https://wftda.com/wftda-leagues/bradentucky-" \
          "bombers-roller-derby-league/" },
      { name: "Beet City Bombers",
        city: "Boise, ID",
        country: "US",
        member?: false,
        profile_url: "https://wftda.com/wftda-leagues/beet-city-bombers/" },
      { name: "Lincolnshire Bombers Roller Derby",
        city: "Lincolnshire, England",
        country: "GB",
        member?: true,
        profile_url: "https://wftda.com/wftda-leagues/lincolnshire-" \
          "bombers-roller-derby/" },
      { name: "Boulder County Bombers",
        city: "Longmont, CO",
        country: "US",
        member?: true,
        profile_url: "https://wftda.com/wftda-leagues/boulder-county-" \
          "bombers/" },
      { name: "Charm City Roller Girls",
        city: "Baltimore, MD",
        country: "US",
        member?: true,
        profile_url: "https://wftda.com/wftda-leagues/charm-city-roller-" \
          "girls/" }
    ]

    expect(DerbyLeagueInfoCli::Scraper::LeagueList.scrape( \
      bomber_subset_url)).to eq(bomber_subset)
  end
end

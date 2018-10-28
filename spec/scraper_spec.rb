require "spec_helper"

RSpec.describe "Scraper" do
  context "LeagueList" do
    context "#scrape_league_list" do
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
  end

  context "LeagueProfile" do
    context "#scrape_profile" do
      recaps_profile = DerbyLeagueInfoCli::Scraper::LeagueProfile.scrape( \
        "https://wftda.com/wftda-leagues/rose-city-rollers/")
      no_recaps_profile = DerbyLeagueInfoCli::Scraper::LeagueProfile.scrape( \
        "https://wftda.com/wftda-leagues/northern-arizona-roller-derby/")

      it "returns a hash with keys for website and game recaps" do
        expect(recaps_profile).to be_an_instance_of(Hash)
        expect(recaps_profile).to have_key(:website)
        expect(recaps_profile).to have_key(:game_recaps)
        expect(no_recaps_profile).to be_an_instance_of(Hash)
        expect(no_recaps_profile).to have_key(:website)
        expect(no_recaps_profile).to have_key(:game_recaps)
      end

      it "has nil for game_recaps if the profile has none" do
        expect(no_recaps_profile[:game_recaps]).to be_nil
      end

      it "has an array of hashes for game_recaps if the profile has them, " \
        "with keys for headline, url, author, and date" do

        expect(recaps_profile[:game_recaps]).to be_an_instance_of(Array)
        expect(recaps_profile[:game_recaps]).to all( have_key(:author) \
                                                     .and have_key(:datetime) \
                                                     .and have_key(:headline) \
                                                     .and have_key(:url) )
      end

      it "has hashes for game recap headlines with keys for year, event, " \
        "game number, and teams. Teams is an array of two strings." do

        expect(recaps_profile[:game_recaps].all? do |recap|
          recap[:headline].is_a?(Hash) \
            && recap[:headline].keys & [:year, :event, :game_number, :teams] \
            && recap[:headline][:teams].size == 2 \
            && recap[:headline][:teams].none?(&:nil?)
        end ).to be true
      end
    end
  end
end

require "spec_helper"

RSpec.describe Scraper::LeagueProfile do
  recaps_profile = Scraper::LeagueProfile.scrape( \
    "https://wftda.com/wftda-leagues/rose-city-rollers/")
  no_recaps_profile = Scraper::LeagueProfile.scrape( \
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

  it "has an array of hashes for game_recaps if the profile has them, with " \
    "keys for year, location, event, game-number, teams, url, author, and " \
    "date" do

    expect(recaps_profile[:game_recaps]).to be_an_instance_of(Array)
    expect(recaps_profile[:game_recaps]).to all( have_key(:author) \
                                                 .and have_key(:datetime) \
                                                 .and have_key(:year) \
                                                 .and have_key(:event) \
                                                 .and have_key(:location) \
                                                 .and have_key(:game_number) \
                                                 .and have_key(:teams) \
                                                 .and have_key(:url) )
  end

  it "Teams is an array of two strings" do
    expect(recaps_profile[:game_recaps].all? do |recap|
      recap[:teams].is_a?(Array) \
        && recap[:teams].size == 2 \
        && recap[:teams].none?(&:nil?) \
        && recap[:teams].all? { |team| team.is_a?(String) }
    end ).to be true
  end

  it "Datetime is a Time" do
    expect(recaps_profile[:game_recaps].all? do |recap|
      recap[:datetime].is_a?(Time)
    end ).to be true
  end
end

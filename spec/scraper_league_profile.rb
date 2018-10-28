require "spec_helper"

RSpec.describe "Scraper::LeagueProfile" do
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

require "spec_helper"

RSpec.describe Scraper do
  context "#scrape_league_list" do
    league_list = Scraper.scrape_league_list( \
      test: "./test_fixtures/small-subset.html"  # comment this line out for online tests
      )
    league_list.freeze

    it "returns an array of hashes with keys for name, city, country, " \
      "membership, and profile_url" do

      expect(league_list).to be_an_instance_of(Array).and \
        all( be_an_instance_of(Hash) ).and \
        all ( have_key(:name).and \
              have_key(:city).and \
              have_key(:country).and \
              have_key(:membership).and \
              have_key(:profile_url) )
    end

    it "Game recaps should be nil or an array of hashes with keys for " \
      "headline, url, author, and date" do

      game_recaps = league_list[:game_recaps].select { |x| !x.nil? }
      expect(game_recaps).to all( be_an_instance_of(Hash) ).and \
        all ( have_key(:headline).and \
              have_key(:url).and \
              have_key(:author).and \
              have_key(:date) )
    end
  end

  context "#scrape_profile" do
    recaps_profile = Scraper.scrape_profile("./test_fixtures/" \
      "wftda-leagues/rose-city-rollers")
    no_recaps_profile = Scraper.scrape_profile("./test_fixtures/" \
      "wftda-leagues/northern-arizona-roller-derby")

    it "returns a hash with keys for website and game recaps" do
      expect(recaps_profile).to be_an_instance_of(Hash).and \
        have_key(:website).and have_key(:game_recaps)
      expect(no_recaps_profile).to be_an_instance_of(Hash).and \
        have_key(:website).and \
        have_key(:game_recaps)
    end

    it "has nil for game_recaps if the profile has none" do
      expect(no_recaps_profile[:game_recaps]).to be_nil
    end

    it "has a hash for game_recaps if the profile has them, with keys for " \
      "headline, url, author, and date" do

      expect(recaps_profile[:game_recaps]).to be_an_instance_of(Hash).and \
        have_key(:headline).and \
        have_key(:url).and \
        have_key(:author).and \
        have_key(:date)
    end

    it "has hashes for game recap headlines with keys for event, game " \
      "number, and other team" do

      expect(recaps_profile[:game_recaps][:headlines]).to \
        be_an_instance_of(Hash).and \
        all ( have_key(:event).and \
              have_key(:game_number).and \
              have_key(:other_team) )
    end
  end
end

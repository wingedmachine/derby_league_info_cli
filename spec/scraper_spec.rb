require "spec_helper"

RSpec.describe Scraper do
  context "#scrape_league_list" do
    test_scrape = Scraper.scrape_league_list( \
      offline_mode: true  # comment this line out for online tests
      )
    test_scrape.freeze

    it "returns an array of hashes with keys for name, city, country, " \
      "membership, website, profile_url, and game_recaps" do

      expect(test_scrape).to be_an_instance_of(Array).and \
        all( be_an_instance_of(Hash) ).and \
        all ( have_key(:name).and \
              have_key(:city).and \
              have_key(:country).and \
              have_key(:membership).and \
              have_key(:website).and \
              have_key(:prifile_url).and \
              have_key(:game_recaps) )
    end

    it "Game recaps should be nil or an array of hashes with keys for " \
      "headline, url, author, and date" do

      game_recaps = test_scrape[:game_recaps].select { |x| !x.nil? }
      expect(game_recaps).to all( be_an_instance_of(Hash) ).and \
        all ( have_key(:headline).and \
              have_key(:url).and \
              have_key(:author).and \
              have_key(:date) )
    end

    it "... with keys for headline, url, author, and date." do
      expect(game_recaps).to all( have_key(:headline).and \
                                  have_key(:url).and \
                                  have_key(:author).and \
                                  have_key(:date) )
    end
  end
end

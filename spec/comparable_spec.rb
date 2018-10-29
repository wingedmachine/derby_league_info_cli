require "spec_helper"

RSpec.describe Comparable do
  context "InstanceMethods" do
    let(:raw_atl_subset) { Scraper::LeagueList.scrape( \
      "https://wftda.com/?s=atlanta&post_type=leagues") }
    let(:atl_subset_1) { LeagueList.create_from_hash_array(raw_atl_subset) }
    let(:atl_subset_2) { LeagueList.create_from_hash_array(raw_atl_subset.dup) }
    let(:atl_sub_subset) { LeagueList.create_from_hash_array( \
      raw_atl_subset[0..-2]) }

    it "correctly determines whether two objects are equal without regard " \
      "for the memory addresses of it or its parts" do
      expect(atl_subset_1).to eq(atl_subset_2)
      expect(atl_subset_1).not_to eq(atl_sub_subset)
    end
  end
end

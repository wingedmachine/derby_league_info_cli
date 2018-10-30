require "spec_helper"

RSpec.describe Comparable do
  context "InstanceMethods" do
    let(:raw_atl_subset) { Scraper::LeagueList.scrape( \
      "https://wftda.com/?s=atlanta&post_type=leagues") }
    let(:object_1) { object = Class.new { include Comparable::InstanceMethods }
                     object.instance_variable_set("@str", "some text")}
    let(:object_2) { object = Class.new { include Comparable::InstanceMethods }
                     object.instance_variable_set("@str", "some text")}
    let(:other_object) { object = Class.new { include Comparable::InstanceMethods }
                    object.instance_variable_set("@str", "some different text")}

    it "correctly determines whether two objects are equal without regard " \
      "for the memory addresses of it or its parts" do
      expect(object_1).to eq(object_2)
      expect(object_1).not_to eq(other_object)
    end
  end
end

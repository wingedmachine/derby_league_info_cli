require "spec_helper"

RSpec.describe League do
  let(:league) { League.new({ name: "Atlanta Rollergirls",
                             country: "US",
                             city: "Atlanta, GA",
                             is_full_member: true,
                             profile_url: "https://wftda.com/wftda-leagues" \
                               "/atlanta-rollergirls/" }) }

  it "should have attr_readers for name, country, city, is_full_member, " \
    "website, and game_recaps" do

    expect(league).to respond_to(:name, :country, :city, :is_full_member, \
      :website, :game_recaps)
    expect(league).not_to respond_to(:name=, :country=, :city=, \
      :is_full_member=, :website=, :game_recaps=)
  end

  it "should load website and game_recaps in from the profile_url" do
    expect(league.website).to be_nil
    expect(league.game_recaps).to be_nil

    league.load_details
    expect(league.website).to eq("http://www.atlantarollergirls.com/")
    expect(league.game_recaps).to all( be_an_instance_of(GameRecap) )
  end
end

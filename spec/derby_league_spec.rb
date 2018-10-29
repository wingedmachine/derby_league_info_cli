require "spec_helper"

RSpec.describe "DerbyLeague" do
  league = DerbyLeague.new({ name: "Atlanta Rollergirls",
                             country: "US",
                             city: "Atlanta, GA",
                             is_full_member: true,
                             profile_url: "https://wftda.com/wftda-leagues" \
                               "/atlanta-rollergirls/" })

  it "should have attr_readers for name, country, city, is_full_member, " \
    "profile_url, website, and game_recaps" do

    expect(league).to respond_to(:name, :country, :city, :is_full_member, \
      :profile_url, :website, :game_recaps)
    expect(league).not_to respond_to(:name=, :country=, :city=, \
      :is_full_member=, :profile_url=, :website=, :game_recaps=)
  end

  it "should load website and game_recaps in from the profile_url" do
    expect(league.website).to eq("http://www.atlantarollergirls.com/")
    expect(league.game_recaps).to all( be_an_instance_of(GameRecap) )
  end
end
require "spec_helper"

RSpec.describe "GameRecap" do
  recap = GameRecap.new({ author: "PullHitzHer Prize",
                          datetime: "2018-09-23T20:50:36+00:00",
                          headline: [ { year: 2018,
                                        event: "Playoffs",
                                        location: "Atlanta",
                                        game_number: 14,
                                        teams: ["Atlanta", "Bay Area"] },
                                      { year: 2018,
                                        event: "Playoffs",
                                        location: "Atlanta",
                                        game_number: 6,
                                        teams: ["Atlanta", "London"] }
                                    ],
                          url: "https://wftda.com/2018-playoffs-atlanta-game-" \
                            "14-atlanta-vs-bay-area/"})

  it "should have attr_readers for author, datetime, headline, and url" do

    expect(recap).to respond_to(:author, :datetime, :headline, :url)
    expect(recap).not_to respond_to(:author=, :datetime=, :headline=, :url=)
  end
end

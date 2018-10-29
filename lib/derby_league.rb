class DerbyLeague
  attr_reader :name, :country, :city, :is_full_member, :profile_url, :website, \
    :game_recaps

  def initialize(league)
    @name = league[:name]
    @country = league[:country]
    @city = league[:city]
    @is_full_member = league[:is_full_member]
    @profile_url = league[:profile_url]

    profile = Scraper::LeagueProfile.scrape(profile_url)
    @website = profile[:website]
    @game_recaps = profile[:game_recaps].map do |recap|
      GameRecap.new(recap)
    end
  end
end

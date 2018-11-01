class League
  include Comparable::InstanceMethods

  attr_reader :name, :country, :city, :is_full_member, :website, :game_recaps

  def initialize(league)
    @name = league[:name]
    @country = league[:country]
    country.add_league(self)
    @city = league[:city]
    @is_full_member = league[:is_full_member]
    @profile_url = league[:profile_url]
  end

  def load_details
    return false if @website

    profile = Scraper::LeagueProfile.scrape(@profile_url)
    @website = profile[:website]
    if profile[:game_recaps] == nil
      @game_recaps = nil
    else
      @game_recaps = profile[:game_recaps].map do |recap|
        GameRecap.new(recap)
      end
    end
  end
end

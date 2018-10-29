class LeagueList
  attr_reader :leagues, :curr_page, :total_pages

  def initialize(leagues, per_page = 10)
    flat_leagues = process_raw_league_data(leagues)
    @leagues = paginate_leagues(flat_leagues, per_page)
    @curr_page = 1
    @total_pages = leagues.size
  end

  def process_raw_league_data(raw_league_data)
    flat_leagues = raw_league_data.map { |league| DerbyLeague.new(league) }
    flat_leagues.sort! { |league_1, league_2| league_1.name <=> league_2.name}
  end

  def paginate_leagues(flat_leagues, per_page)
      leagues = []
      while flat_leagues.size > 10
        new_page = []
        per_page.times do
          new_page << flat_leagues.shift
        end
        leagues << new_page
      end
      leagues << flat_leagues
  end

  def ==(other)
    self.class == other.class && self.leagues == other.leagues
  end
end

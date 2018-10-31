class Country
  include Comparable::InstanceMethods

  attr_reader :code, :leagues, :name

  def initialize(code, name)
    @code = code
    @league_array = []
    @name = name
  end

  def add_league(league)
    @league_array << league unless @league_array.include?(league)
  end

  def finalize_leagues
    @leagues = LeagueList.new(@league_array)
  end
end

require 'pageable/pageable'

class LeagueList
  extend Pageable::ClassMethods
  include Pageable::InstanceMethods

  attr_reader :leagues

  def initialize(leagues, per_page = 10)
    super(process_raw_league_data(leagues), per_page)
  end

  def process_raw_league_data(raw_league_data)
    flat_leagues = raw_league_data.map { |league| DerbyLeague.new(league) }
    flat_leagues.sort! { |league_1, league_2| league_1.name <=> league_2.name}
  end
end

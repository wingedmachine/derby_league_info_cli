require 'pageable/pageable'

class LeagueList
  extend Pageable::ClassMethods
  include Pageable::InstanceMethods

  attr_reader :leagues

  def initialize(leagues, per_page = 10)
    flat_leagues = leagues.map { |league| DerbyLeague.new(league) }
    flat_leagues.sort! { |league_1, league_2| league_1.name <=> league_2.name}
    super(flat_leagues, per_page)
  end

  def find_by_country_code(code)

  end

  def search_by_name(input)

  end

  def search_by_location(input)

  end
end

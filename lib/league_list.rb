class LeagueList
  extend Pageable::ClassMethods
  include Comparable::InstanceMethods
  include Pageable::InstanceMethods

  attr_reader :countries

  def initialize(leagues, per_page = Pageable::PerPageDefault)
    leagues.sort! { |league_1, league_2| league_1.name <=> league_2.name}
    super(leagues, per_page)
    @countries = single_page.map(&:country).uniq
  end

  def self.create_initial_list(raw_leagues, countries, per_page = \
    Pageable::PerPageDefault)

    LeagueList.new(raw_leagues.map { |league| League.new(league) }, per_page)
  end

  def search_by_name(input)
    matching_leagues = single_page.select do |league|
      league.name.downcase.include?(input)
    end
    LeagueList.new(matching_leagues)
  end

  def search_by_location(input)
    matching_leagues = single_page.select do |league|
      league.city.downcase.include?(input) \
        || league.country.name.downcase.include?(input)
    end
    LeagueList.new(matching_leagues)
  end

  def self.search_by_country(league_list, country)
    LeagueList.new(league_list.single_page.select do |league|
      league.country == country
    end)
  end
end

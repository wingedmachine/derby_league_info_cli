class LeagueList
  extend Pageable::ClassMethods
  include Comparable::InstanceMethods
  include Pageable::InstanceMethods

  def countries
    @countries ||= CountryList.new(single_page.map(&:country).uniq)
  end

  def initialize(leagues, per_page = Pageable::PerPageDefault)
    leagues.sort! { |league_1, league_2| league_1.name <=> league_2.name}
    super(leagues, per_page)
  end

  def self.create_initial_list(raw_leagues, countries, per_page = \
    Pageable::PerPageDefault)

    leagues = raw_leagues.map do |league|
      leagues_country = countries.single_page.detect do |country|
        country.code == league[:country_code]
      end
      League.new(league, leagues_country)
    end
    LeagueList.new(leagues, per_page)
  end

  def find_by_country_code(code)
    countries.single_page.detect { |country| country.code == code}.leagues
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
end

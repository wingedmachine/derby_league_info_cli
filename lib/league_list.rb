class LeagueList
  extend Pageable::ClassMethods
  include Comparable::InstanceMethods
  include Pageable::InstanceMethods

  def initialize(leagues, per_page = Pageable::PerPageDefault)
    leagues.sort! { |league_1, league_2| league_1.name <=> league_2.name}
    super(leagues, per_page)
  end

  def self.create_initial_list(raw_leagues, all_countries, per_page = \
    Pageable::PerPageDefault)

    @@all_countries = all_countries
    LeagueList.new(raw_leagues.map { |league| League.new(league) }, per_page)
  end

  def find_by_country_code(code)
    leagues_in_country = single_page.select do |league|
      league.country == code
    end
    LeagueList.new(leagues_in_country)
  end

  def search_by_name(input)
    matching_leagues = single_page.select do |league|
      league.name.downcase.include?(input)
    end
    LeagueList.new(matching_leagues)
  end

  def search_by_location(input)
    matching_leagues = single_page.select do |league|
      league.city.downcase.include?(input) # \
        #|| all_countries.find_by_code(league.country).downcase.include?(input)
    end
    LeagueList.new(matching_leagues)
  end
end

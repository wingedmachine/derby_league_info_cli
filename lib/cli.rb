class CLI
  attr_reader :all_countries, :all_leagues

  def start
    CLI.loading
    load_initial
    CLI.greet
    main_loop
    CLI.goodbye
  end

  def load_initial
    countries = Scraper::CountryCodes.scrape
    leagues = Scraper::LeagueList.scrape
    countries_with_leagues = leagues.map { |league| league[:country] }.uniq
    countries.keep_if { |key, value| countries_with_leagues.include?(key.to_s) }
    @all_leagues = LeagueList.create_from_hash_array(leagues).freeze
    @all_countries = CountryList.new(countries).freeze
  end

  def main_loop
    input = nil
    until input == "exit"
      puts "Waht do?"
      input = gets.downcase.strip
    end
  end

  def self.loading
    puts "loading..."
  end

  def self.greet
    puts "Welcome to the DLIC"
  end

  def self.goodbye
    puts "Have a nice day!"
  end
end

class CLI
  attr_reader :all_countries, :all_leagues

  def start
    loading
    load_initial
    greet
    main_loop
    goodbye
  end

  def load_initial

  # countries_with_leagues = leagues.map { |league| league[:country] }.uniq
  # countries.keep_if { |key, value| countries_with_leagues.include?(key.to_s) }
  #   @all_leagues = LeagueList.create_initial_list( \
  #     Scraper::LeagueList.scrape, Scraper::CountryCodes.scrape).freeze
  end

  def main_loop
    input = nil
    until input == "exit"
      puts "Waht do?"
      input = gets.downcase.strip
    end
  end

  def loading
    puts "loading..."
  end

  def greet
    puts "Welcome to the DLIC"
  end

  def goodbye
    puts "Have a nice day!"
  end
end

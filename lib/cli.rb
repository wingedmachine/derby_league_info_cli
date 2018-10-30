class CLI
  def start
    initial_setup
    main_loop
  end

  private

  def initial_setup
    tell_user_data_is_loading
    # below line lays groundwork for allowing user-suppplied value via argument
    # in a hypothetical future update
    @items_per_page = Pageable::PerPageDefault
    leagues = Scraper::LeagueList.scrape
    countries = Scraper::CountryCodes.scrape
    countries_with_leagues = leagues.map { |league| league[:country] }.uniq
    countries.keep_if { |key, value| countries_with_leagues.include?(key.to_s) }
    @all_leagues = LeagueList.create_initial_list(leagues, countries)
    greet
  end

  def tell_user_data_is_loading
    puts "loading..."
  end

  def greet
    puts "    Welcome to the DLIC!\n" \
         "type HELP to see available commands"
  end

  def main_loop
    input = nil
    until input == "exit"
      exec_command(input)
      print "DLIC > "
      input = gets.downcase.strip
    end
  end

  def exec_command(raw_command)
    return nil if raw_command == nil

    command = process_command(raw_command)
    case command[0]
    when (1..@items_per_page)
    when "search"
    when "countries"
    when "leagues"
    when "next"
    when "prev"
    when "page"
    when "reset"
    when "undo"
    when "help"
      show_help
    else
      puts "I don't recognize that command"
    end
  end

  def process_command(command)
    words = command.split(" ")
    words[0] = words[0].to_i if words[0].to_i != 0
    [words[0], [words[1..-1]]]
  end

  def show_help
    puts \
      "Navigation\n" \
     "  Entering the number of an item on screen will select it\n" \
     "  'COUNTRIES' will display a list of countries that contain leagues\n" \
     "  'LEAGUES' will return to the list of leagues from the country list\n" \
     "  'NEXT' and 'PREV' will give the next and previous pages of options\n" \
     "  'PAGE [number]' will turn directly to that page\n" \
     "  'RESET' will return to the starting screen\n" \
     "  'UNDO' will remove the most recent search made\n" \
     "\n" \
     "Searching\n" \
     "  If the screen is currently displaying leagues, then:\n" \
     "    'SEARCH [search term]' will search for leagues by name\n" \
     "    'SEARCH -L [search term]' will search for leagues by location\n" \
     "  If the screen is currently displaying countries, then:\n" \
     "    'SEARCH [search term]' will search for countries by name\n" \
     "  Adding -n will always search within the previous search results"
  end
end

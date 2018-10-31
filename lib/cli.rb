class CLI
  def start
    initial_setup
    main_loop
  end

  def current_subset
    @subset_stack.last
  end

  private

  def initial_setup
    # below line lays groundwork for allowing user-suppplied value via argument
    # in a hypothetical future update
    @items_per_page = Pageable::PerPageDefault

    puts "Loading league data..."
    leagues = Scraper::LeagueList.scrape

    puts "Loading country data..."
    countries = Scraper::Countries.scrape

    puts "Cross-referencing data..."
    countries_with_leagues = leagues.map { |league| league[:country] }.uniq
    countries.select { |key, value| countries_with_leagues.include?(key.to_s) }

    puts "Creating data structures..."
    country_list = CountryList.create_initial_list(countries)
    @all_leagues = LeagueList.create_initial_list(leagues, country_list)
    @subset_stack = [@all_leagues]
  end

  def main_loop
    greet
    current_subset.display_current_page
    input = nil
    until input == "exit"
      exec_command(input)
      print "DLIC > "
      input = gets.downcase.strip
    end
  end

  def greet
    puts "\n" \
         "Welcome to the DLIC!\n" \
         "type HELP to see available commands"
  end

  def exec_command(raw_command)
    return nil if raw_command == nil

    command = process_command(raw_command)

    # Extra words included in the command will be ignored. For example,
    # 'help me move this sofa up these stairs' will be treated as 'help'.
    # On the other hand 'search -l Australia is the best country' will
    # come up empty, as no locations include "Australia is the best country"

    case command[0]
    when (1..@items_per_page)
    when "search" then do_search(command[1..-1])
    when "countries"
    when "leagues"
    when "next" then do_next
    when "prev" then do_prev
    when "page" then do_page(command[1])
    when "reset" then do_reset
    when "undo" then do_undo
    when "help" then do_help
    else
      puts "I don't recognize that command"
    end
  end

  def process_command(command)
    words = command.split(" ")
    words[0] = words[0].to_i if words[0].to_i != 0
    [words[0], [words[1..-1]]].flatten
  end

  def do_search(arguments)
    @subset_stack << if current_subset.is_a?(LeagueList)
                       do_league_search(arguments)
                     else
                       do_country_search(arguments[0])
                     end
    current_subset.display_current_page
  end

  def do_league_search(arguments)
    if arguments[0].upcase == "-L"
      do_league_location_search(arguments[1..-1].join(" "))
    else
      do_league_name_search(arguments[0..-1].join(" "))
    end
  end

  def do_league_location_search(search_term)
    current_subset.search_by_location(search_term)
  end

  def do_league_name_search(search_term)
    current_subset.search_by_name(search_term)
  end

  def do_country_search(search_term)

  end

  def do_next
    current_subset.next_page
    current_subset.display_current_page
  end

  def do_prev
    current_subset.prev_page
    current_subset.display_current_page
  end

  def do_page(page)
    if page != nil && (page.to_i != 0 || page ==  "0")
      current_subset.turn_to(page.to_i)
      current_subset.display_current_page
    else
      puts "You must specify a page number"
    end
  end

  def do_reset
    @subset_stack = [@all_leagues]
    current_subset.turn_to(1)
    current_subset.display_current_page
  end

  def do_undo
    if @subset_stack.size > 1
      @subset_stack.pop
      current_subset.turn_to(1)
    else
      puts "No search to undo"
    end
    current_subset.display_current_page
  end

  def do_help
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

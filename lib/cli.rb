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
    countries_with_leagues = leagues.map { |league| league[:country_code] }.uniq
    countries.select { |country| countries_with_leagues.include?(country[1]) }

    puts "Creating data structures..."
    country_list = CountryList.create_initial_list(countries)
    @all_leagues = LeagueList.create_initial_list(leagues, country_list)
    @subset_stack = [@all_leagues]
    @search_stack = []
  end

  def main_loop
    greet
    display_current_page
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

  def display_current_page
    display_title
    current_subset.display_current_page
  end

  def display_title
    title = "All Leagues"
    puts "\n" \
         "#{title}"
  end

  def exec_command(raw_command)
    return nil if raw_command == nil

    command = process_command(raw_command)

    # Extra words included in the command will be ignored. For example,
    # 'help me move this sofa up these stairs' will be treated as 'help'.
    # On the other hand 'search -l Australia is the best country' will
    # come up empty, as no locations include "Australia is the best country"

    case command[0]
    when (1..@items_per_page) then choose(command[0])
    when "search" then search(command[1..-1])
    when "countries" then show_countries
    when "leagues" then show_leagues
    when "next" then next_page
    when "prev" then prev
    when "page" then page(command[1])
    when "reset" then reset
    when "undo" then undo
    when "help" then show_help
    else
      puts "I don't recognize that command"
    end
  end

  def process_command(command)
    words = command.split(" ")
    words[0] = words[0].to_i if words[0].to_i != 0
    [words[0], [words[1..-1]]].flatten
  end

  def search(arguments)
    search_results = if !current_subset.is_a?(LeagueList) \
                       || arguments[0].upcase != "-L"

                       name_search(arguments[0..-1].join(" "))
                     else
                       league_location_search(arguments[1..-1].join(" "))
                     end
    return nil unless search_results.is_a?(CountryList) \
      || search_results.is_a?(LeagueList)

    @subset_stack << search_results
    @search_stack << arguments
    display_current_page
  end

  def league_location_search(search_term)
    current_subset.search_by_location(search_term)
  end

  def name_search(search_term)
    current_subset.search_by_name(search_term)
  end

  def show_countries
    if current_subset.is_a?(LeagueList)
      if @subset_stack[-2] != current_subset.countries
        @subset_stack << current_subset.countries
        display_current_page
      else
        undo
      end
    else
      puts "Already viewing countries"
    end
  end

  def show_leagues
    if current_subset.is_a?(CountryList)
      new_league_list = LeagueList.new(current_subset.leagues)
      if @subset_stack[-2] != new_league_list
        @subset_stack << new_league_list
        display_current_page
      else
        undo
      end
    else
      puts "Already viewing leagues"
    end
  end

  def next_page
    current_subset.next_page
    display_current_page
  end

  def prev
    current_subset.prev_page
    display_current_page
  end

  def page(page)
    if page != nil && (page.to_i != 0 || page ==  "0")
      current_subset.turn_to(page.to_i)
      display_current_page
    else
      puts "You must specify a page number"
    end
  end

  def reset
    @subset_stack = [@all_leagues]
    current_subset.turn_to(1)
    display_current_page
  end

  def undo
    if @subset_stack.size > 1
      @subset_stack.pop
      @search_stack.pop
      current_subset.turn_to(1)
    else
      puts "No search to undo"
    end
    display_current_page
  end

  def show_help
    puts \
      "Navigation\n" \
     "  Entering the number of an item on screen will select it\n" \
     "  'COUNTRIES' will display a list of the current leagues' countries\n" \
     "  'LEAGUES' will display a list of the current countries' leagues\n" \
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

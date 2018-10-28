require "bundler/setup"
require "derby_league"
require "derby_league_info_cli"
require "game_recap"
require "scraper/country_codes"
require "scraper/league_list"
require "scraper/league_profile"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

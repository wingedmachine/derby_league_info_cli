require 'nokogiri'
require 'open-uri'

module Scraper
  class LeagueList
      def self.scrape(url = "https://wftda.com/wftda-leagues/")
        doc = Nokogiri::HTML(open(url))
        leagues = doc.search("div.leagues-item")
        leagues.map do |league|
          location = get_location(league)
          { name: get_league_name(league),
            city: location[0],
            country: location[1],
            is_full_member: get_membership(league),
            profile_url: get_profile_url(league)
          }
        end
      end

      private_class_method
      def self.get_location(league)
        raw_location = league.search("div.league-location").text
        country = league.search("span.league_country").text
        city = raw_location.sub(country, "").sub(Nokogiri::HTML("&nbsp;") \
          .text, "").strip.chop
        [city, country.upcase]
      end

      private_class_method
      def self.get_league_name(league)
        league.search("span.league_name").text
      end

      private_class_method
      def self.get_membership(league)
        league.attribute("class").value.include?("league_type-member")
      end

      private_class_method
      def self.get_profile_url(league)
        "https://wftda.com#{league.search("h5 > a").attribute("href").value}"
      end
    end
end

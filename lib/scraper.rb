require 'nokogiri'
require 'open-uri'
require 'pry'

module DerbyLeagueInfoCli
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
            member?: get_membership(league),
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

    class LeagueProfile
      def self.scrape(url)
        doc = Nokogiri::HTML(open(url))
        { game_recaps: get_game_recaps(doc),
          website: get_league_website(doc)
        }
      end

      private_class_method
      def self.get_game_recaps(doc)
        parse_recaps(get_raw_recaps(doc))
      end

      private_class_method
      def self.get_raw_recaps(doc)
        doc.search("ul.league-event-list")
      end

      private_class_method
      def self.parse_recaps(raw_recaps)
        return nil unless recaps_available?(raw_recaps)

        wert = raw_recaps.map do |recap|
          { author: parse_author(recap),
            datetime: parse_datetime(recap),
            headline: parse_headline(recap),
            url: parse_url(recap)
          }
        end
      end

      private_class_method
      def self.recaps_available?(raw_recaps)
        raw_recaps.search("div.league-event-meta").first.text.strip \
          != "No game recaps at this time."
      end

      private_class_method
      def self.parse_author(recap)
        meta = recap.search("div.league-event-meta")
        time_text = meta.search("time").text
        meta.text.sub(time_text, "").sub("|", "").strip
      end

      private_class_method
      def self.parse_datetime(recap)
        recap.search("div.league-event-meta > time").attribute("datetime").value
      end

      private_class_method
      def self.parse_headline(recap)
        raw_headline = recap.search("div.event-title > a").text
        headline_data = raw_headline.split(/( Game |: | vs\.? )/)
        headline_data = headline_data.values_at(* headline_data.each_index \
          .select(&:even?) )
        year = headline_data[0].split(" ").first
        location = headline_data[0].split(/(Championships |Playoffs )/).last
        { year: year,
          event: headline_data[0].sub(year, "").sub(location, "").strip,
          location: location,
          game_number: headline_data[1].to_i,
          teams: [headline_data[2], headline_data[3]]
        }
      end

      private_class_method
      def self.parse_url(recap)
        "https://wftda.com#{recap.search("div.event-title > a").attribute("href").value}"
      end

      private_class_method
      def self.get_league_website(doc)
        contact_info = doc.search("p.league-contact > a")
        contact_info.empty? ? nil : contact_info.first.attribute("href").value
      end
    end

    class CountryCodes
    end
  end
end

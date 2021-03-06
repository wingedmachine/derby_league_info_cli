module Scraper
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

        raw_recaps.map do |recap|
          headline = parse_headline(recap)
          { author: parse_author(recap),
            datetime: parse_datetime(recap),
            year: headline[:year],
            event: headline[:event],
            location: headline[:location],
            game_number: headline[:game_number],
            teams: headline[:teams],
            url: parse_url(recap)
          }
        end
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
        Time.new(recap.search("div.league-event-meta > time").attribute( \
          "datetime").value)
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
end

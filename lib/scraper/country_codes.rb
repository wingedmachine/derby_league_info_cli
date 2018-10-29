module Scraper
  class CountryCodes
    def self.scrape(url = "https://www.nationsonline.org/oneworld/country" \
        "_code_list.htm")
      doc = Nokogiri::HTML(open(url))
      countries = {}
      doc.search("tr").select do |row|
        next if row.search("td")[1].attribute("colspan")&.value == "4"

        cells = row.search("td")
        countries[cells[2].text.strip.to_sym] = cells[1].text.strip
      end
      countries
    end
  end
end

module Scraper
  class Countries
    def self.scrape(url = "https://www.nationsonline.org/oneworld/country" \
        "_code_list.htm")
      doc = Nokogiri::HTML(open(url))
      doc.search("tr").map do |row|
        next if row.search("td")[1].attribute("colspan")&.value == "4"

        cells = row.search("td")
        [cells[2].text.strip, cells[1].text.strip]
      end.select { |country| !country.nil?}
    end
  end
end

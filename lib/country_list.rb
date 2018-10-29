require 'scraper/country_codes'

class CountryList
  attr_reader :countries

  def initialize(countries)
    @countries = countries
  end

  def find_by_code(code)
    countries[code.to_sym]
  end

  def search_by_name(input)
    CountryList.new(countries.select { |key, value| value.upcase.include? \
      (input.upcase) })
  end

  def ==(other)
    self.class == other.class && self.countries == other.countries
  end
end

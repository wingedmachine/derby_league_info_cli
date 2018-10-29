require 'pageable/pageable'

class CountryList
  extend Pageable::ClassMethods
  include Pageable::InstanceMethods

  attr_reader :country_codes

  def initialize(country_codes, per_page = 10)
    @country_codes = country_codes
    super(country_codes.map { |key, value| value }.sort, per_page)
  end

  def find_by_code(code)
    countries[code.to_sym]
  end

  def search_by_name(input)
    CountryList.new(countries.select { |key, value| value.upcase.include? \
      (input.upcase) })
  end
end

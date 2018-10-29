require 'comparable/comparable'
require 'pageable/pageable'

class CountryList
  extend Pageable::ClassMethods
  include Comparable::InstanceMethods
  include Pageable::InstanceMethods

  attr_reader :country_codes

  def initialize(country_codes, per_page = 10)
    @country_codes = country_codes
    super(country_codes.map { |key, value| value }.sort, per_page)
  end

  def find_by_code(code)
    country_codes[code.to_sym]
  end

  def search_by_name(input)
    CountryList.new(country_codes.select { |key, value| value.upcase.include? \
      (input.upcase) })
  end
end

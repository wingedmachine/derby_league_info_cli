require 'listable/listable'
require 'pageable/pageable'

class CountryList
  extend Pageable::ClassMethods
  include Listable::InstanceMethods
  include Pageable::InstanceMethods

  attr_reader :country_names, :countries

  def initialize(countries, per_page = 10)
    @countries = countries
    super(@countries)
    sorted_names = countries.map { |key, value| value }.sort
    @country_names = self.class.paginate_array(sorted_names, per_page)
  end

  def find_by_code(code)
    countries[code.to_sym]
  end

  def search_by_name(input)
    CountryList.new(countries.select { |key, value| value.upcase.include? \
      (input.upcase) })
  end
end

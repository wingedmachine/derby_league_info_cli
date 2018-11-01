require 'comparable/comparable'
require 'pageable/pageable'

class CountryList
  extend Pageable::ClassMethods
  include Comparable::InstanceMethods
  include Pageable::InstanceMethods

  def leagues
    @leagues ||= single_page.map(&:leagues).flatten.uniq
  end

  def initialize(countries, per_page = Pageable::PerPageDefault)
    countries.sort! do |country_1, country_2|
      country_1.name.downcase <=> country_2.name.downcase
    end
    super(countries, per_page)
  end

  def search_by_name(input)
    CountryList.new(single_page.select { |country| country.name.downcase \
      .include?(input) })
  end
end

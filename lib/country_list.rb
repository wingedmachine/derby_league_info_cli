require 'comparable/comparable'
require 'pageable/pageable'

class CountryList
  extend Pageable::ClassMethods
  include Comparable::InstanceMethods
  include Pageable::InstanceMethods

  def initialize(countries, per_page = Pageable::PerPageDefault)
    countries.sort! do |country1, country_2|
      country1.name.downcase <=> country_2.name.downcase
    end
    super(countries, per_page)
  end

  def leagues
    single_page.map()
  end

  def self.create_initial_list(hash, per_page = Pageable::PerPageDefault)
    countries = hash.map { |key, value| Country.new(key, value) }
    CountryList.new(countries, per_page)
  end

  def find_name_by_code(code)
    single_page.detect { |country| country.code == code }.name
  end

  def search_by_name(input)
    CountryList.new(single_page.select { |country| country.name.downcase \
      .include?(input) })
  end
end

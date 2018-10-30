require 'spec_helper'

RSpec.describe CountryList do
  let(:united_and_of) { [ Country.new("TZ", "Tanzania, United Republic of"),
                          Country.new("US", "United States of America") ] }
  let(:united) { [ Country.new("AE", "United Arab Emirates"),
                   Country.new("GB", "United Kingdom") ] }

  let(:country_list) { CountryList.new([ Country.new("AF", "Afghanistan"),
                                         Country.new("SV", "El Salvador"),
                                         Country.new("FI", "Finland"),
                                         Country.new("IN", "India"),
                                         Country.new("JP", "Japan"),
                                         Country.new("TR", "Turkey"),
                                         Country.new("ZW", "Zimbabwe"),
                                         *united,
                                         *united_and_of]) }
  let(:united_list) { CountryList.new([united, united_and_of].flatten) }
  let(:united_and_of_list) { CountryList.new(united_and_of) }

  it "#find_name_by_code returns a country's full name when supplied its code" do
    expect(country_list.find_name_by_code("AF")).to eq("Afghanistan")
    expect(country_list.find_name_by_code("SV")).to eq("El Salvador")
    expect(country_list.find_name_by_code("FI")).to eq("Finland")
    expect(country_list.find_name_by_code("IN")).to eq("India")
    expect(country_list.find_name_by_code("JP")).to eq("Japan")
    expect(country_list.find_name_by_code("TR")).to eq("Turkey")
    expect(country_list.find_name_by_code("ZW")).to eq("Zimbabwe")
  end

  it "#search_by_name returns a new CountryList of countries whose name " \
    "matches the supplied string, ignoring case" do

    expect(country_list.search_by_name("united")).to eq(united_list)
    expect(united_list.search_by_name("of")).to eq(united_and_of_list)
  end

  it "orders countries alphabetically by name" do
    expect(country_list.single_page).to eq(country_list.single_page.sort \
      do |country1, country_2|
        country1.name.downcase <=> country_2.name.downcase
      end)
  end
end

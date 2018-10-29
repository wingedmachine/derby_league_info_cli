require 'spec_helper'

RSpec.describe CountryList do
  country_list = CountryList.new(Scraper::CountryCodes.scrape)

  it "#find_by_code returns a country's full name when supplied its code" do
    expect(country_list.find_by_code("AF")).to eq("Afghanistan")
    expect(country_list.find_by_code("SV")).to eq("El Salvador")
    expect(country_list.find_by_code("FI")).to eq("Finland")
    expect(country_list.find_by_code("IN")).to eq("India")
    expect(country_list.find_by_code("JP")).to eq("Japan")
    expect(country_list.find_by_code("TR")).to eq("Turkey")
    expect(country_list.find_by_code("ZW")).to eq("Zimbabwe")
  end

  it "#search_by_name returns a new CountryList of countries whose name " \
    "matches the supplied string, ignoring case" do

    results = CountryList.new({ TZ: "Tanzania, United Republic of",
                                AE: "United Arab Emirates",
                                GB: "United Kingdom",
                                US: "United States of America" })
    sub_results = CountryList.new({ TZ: "Tanzania, United Republic of",
                                    US: "United States of America" })

    expect(country_list.search_by_name("united")).to eq(results)
    expect(results.search_by_name("OF")).to eq(sub_results)
  end

  it "orders countries alphabetically by name" do
    name_array = country_list.country_names.flatten
    expect(name_array).to eq(name_array.sort)
  end

  it "divides the list into 10 country pages" do
    expect(country_list.country_names[0..-2].map { |country| country.size  \
      == 10 }).to all( be(true) )
    expect(country_list.country_names.last.size).to be <= 10
  end

  xit "#next_page returns the next page if there is one" do end

  xit "#prev_page returns the prev page if there is one" do end

  xit "#turn_to returns a specific page if it exists" do end
end

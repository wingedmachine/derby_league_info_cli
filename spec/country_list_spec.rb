require 'spec_helper'

RSpec.describe CountryList do
  let(:united_and_of) { [ Country.new({ name: "Tanzania, United Republic of",
                                        code: "TZ" }),
                          Country.new({ name: "United States of America",
                                        code: "US" }) ] }
  let(:united) { [ Country.new({ code: "AE",
                                 name: "United Arab Emirates" }),
                   Country.new({ code: "GB",
                                 name: "United Kingdom" }) ] }
  let(:country_list) { CountryList.new([ Country.new({ code: "AF",
                                                       name: "Afghanistan" }),
                                         Country.new({ code: "SV",
                                                       name: "El Salvador" }),
                                         Country.new({ code: "FI",
                                                       name: "Finland" }),
                                         Country.new({ code: "IN",
                                                       name: "India" }),
                                         Country.new({ code: "JP",
                                                       name: "Japan" }),
                                         Country.new({ code: "TR",
                                                       name: "Turkey" }),
                                         Country.new({ code: "ZW",
                                                       name: "Zimbabwe" }),
                                         *united,
                                         *united_and_of ]) }

   let(:united_list) { CountryList.new(united.push(*united_and_of)) }

  it "#search_by_name returns a new CountryList of countries whose name " \
    "matches the supplied string, ignoring case" do

    expect(country_list.search_by_name("united")).to eq(united_list)
    expect(united_list.search_by_name("of")).to eq(CountryList.new(united_and_of))
  end

  it "orders countries alphabetically by name" do
    expect(country_list.single_page).to eq(country_list.single_page.sort \
      do |country1, country_2|
        country1.name.downcase <=> country_2.name.downcase
      end)
  end
end

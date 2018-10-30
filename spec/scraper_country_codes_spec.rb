require "spec_helper"

RSpec.describe Scraper::CountryCodes do
  it "returns a hash of countries as \"code: full_name\"" do
    country_codes = Scraper::CountryCodes.scrape
    expect(country_codes).to include( AF: "Afghanistan",
                                      SV: "El Salvador",
                                      FI: "Finland",
                                      IN: "India",
                                      JP: "Japan",
                                      TR: "Turkey",
                                      ZW: "Zimbabwe" )
    expect(country_codes.keys).to all( match(/\A[A-Z]{2}\z/) )
    expect(country_codes.values).to all (be_an_instance_of(String))
  end
end

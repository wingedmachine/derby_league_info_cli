require "spec_helper"

RSpec.describe Scraper::Countries do
  it "returns an array of countries as [code, full_name]" do
    countries = Scraper::Countries.scrape
    expect(countries).to include( ["AF", "Afghanistan"],
                                  ["SV", "El Salvador"],
                                  ["FI", "Finland"],
                                  ["IN", "India"],
                                  ["JP", "Japan"],
                                  ["TR", "Turkey"],
                                  ["ZW", "Zimbabwe"] )
    expect(countries.all? do |country|
      country[0].match(/\A[A-Z]{2}\z/) \
        && country[1].is_a?(String)
      end).to be (true)
  end
end

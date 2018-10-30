require "spec_helper"

RSpec.describe Country do
  let(:country) { Country.new("RO", "Rolisica") }

  it "should have attr_readers for name and code" do
    expect(country).to respond_to(:name, :code)
    expect(country).not_to respond_to(:name=, :code=)
  end
end

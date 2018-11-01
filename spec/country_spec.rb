require "spec_helper"

RSpec.describe Country do
  let(:country) { Country.new({ code:"RO",
                                name: "Rolisica"}) }

  it "should have attr_readers for name, code, and leagues" do
    expect(country).to respond_to(:name, :code, :leagues)
    expect(country).not_to respond_to(:name=, :code=, :leagues=)
  end
end

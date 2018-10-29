require 'spec_helper'

RSpec.describe Pageable do
  let(:dummy_instance) { Class.new {
    extend Pageable::ClassMethods
    include Pageable::InstanceMethods }.new((0..4).to_a, 1) }

  let(:standard_page_size) { 10 }
  let(:odd_page_size) { 13 }
  let(:big_prime_number) { 97 }
  let(:big_prime_range_array) { (1..97).to_a}
  let(:standard_pages) { dummy_instance.class.paginate_array( \
    big_prime_range_array) }
  let(:odd_sized_pages) { dummy_instance.class.paginate_array( \
    big_prime_range_array, odd_page_size) }

  context "ClassMethods" do
    it "ClassMethods#paginate_array divides the list into pages" do
      expect(standard_pages[0..-2].map(&:size)).to all eq(standard_page_size)
      expect(standard_pages.last.size).to be <= standard_page_size
      expect(odd_sized_pages[0..-2].map(&:size)).to all eq(odd_page_size)
      expect(odd_sized_pages.last.size).to be <= odd_page_size
    end
  end

  context "InstanceMethods" do
    it "has attr_readers for curr_page_num, pages, and total_pages" do
      expect(dummy_instance).to respond_to(:curr_page_num, :pages, :total_pages)
    end

    it "#next_page returns the next page if there is one" do
      expect(dummy_instance.next_page).to eq([1])
      allow(dummy_instance).to receive(:curr_page_num) \
        { dummy_instance.pages.size }
      expect(dummy_instance.next_page).to be_nil
    end

    it "#prev_page returns the prev page if there is one" do
      expect(dummy_instance.prev_page).to be_nil
      allow(dummy_instance).to receive(:curr_page_num) \
        { dummy_instance.pages.size }
      expect(dummy_instance.prev_page).to eq([3])
    end

    it "#turn_to returns a specific page if it exists" do
      expect(dummy_instance.turn_to(-1)).to be_nil
      expect(dummy_instance.turn_to(dummy_instance.pages.size + 1)).to be_nil
      expect(dummy_instance.turn_to(3)).to eq([2])
    end
  end
end

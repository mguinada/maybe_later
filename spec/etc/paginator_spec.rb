require 'spec_helper'

describe Mongoid::Paginator, "paginates a scope" do
  before :all do
    class TestSubject
      include Mongoid::Document
      include Mongoid::Paginator

      field :value, type: String
    end

    @num_items = 27
    @num_items.times do |i|
      TestSubject.create!(val: i + 1)
    end
  end

  after :all do
    TestSubject.delete_all
  end

  let!(:num_items) { @num_items }

  it "adds the concept of page" do
    TestSubject.page(1).class.include?(Mongoid::Paginator::Page).should be_true
  end

  #it "defines the page size" do
  #  TestSubject.page(1).per_page(3).page_size.should be(3)
  #end

  it "accounts for the current page number" do
    TestSubject.page(3).page_number.should be(3)
  end

  it "accounts for previous pages count" do
    TestSubject.page(3).previous_pages_count.should be(2)
  end

  it "accounts for following pages count" do
    TestSubject.page(3).following_pages_count.should be(3)
  end

  it "accounts for total page count" do
    TestSubject.page(3).total_page_count.should be(6)
  end
end



require "test/helper"
require 'xmlss/item_set'

module Xmlss
  class ItemSetTest < Test::Unit::TestCase

    context "Xmlss::ItemSet" do
      subject { ItemSet.new(:test) }

      should_have_reader :name

      should "be an Array" do
        assert_kind_of ::Array, subject
        assert_respond_to subject, :each
        assert subject.empty?
      end

      context "for generating XML" do
        should_have_reader :xml
        should_build_node
        should_build_no_attributes_by_default(ItemSet)
      end
    end

  end
end
require "assert"
require 'xmlss/item_set'

module Xmlss
  class ItemSetTest < Assert::Context
    desc "Xmlss::ItemSet"
    subject { ItemSet.new(:test) }

    should have_reader :name

    should "be an Array" do
      assert_kind_of ::Array, subject
      assert_respond_to :each, subject
      assert_empty subject
    end

  end

  class ItemSetXmlTest < ItemSetTest
    desc "for generating XML"

    should have_reader :xml
    should_build_node
    should_build_no_attributes_by_default(ItemSet)
  end

end

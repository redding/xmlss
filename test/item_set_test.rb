require "test/helper"
require 'xmlss/item_set'

module Xmlss
  class ItemSetTest < Test::Unit::TestCase

    context "Xmlss::ItemSet" do
      subject { ItemSet.new(:test) }

      should_have_instance_method :xml, :xml_build
      should_have_reader :name

      should "be an Array" do
        assert_kind_of ::Array, subject
        assert_respond_to subject, :each
        assert subject.empty?
      end
    end

  end
end
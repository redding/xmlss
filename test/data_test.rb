require "test/helper"
require 'xmlss/data'

module Xmlss
  class DataTest < Test::Unit::TestCase

    context "Xmlss::Data" do
      subject { Data.new }

      should_have_accessor :type, :value

      should "set it's defaults" do
        assert_equal Data.type(:string), subject.type
        assert_equal "", subject.value
      end

      context "when using explicit type" do
        subject do
          Data.new(12, {:type => :string})
        end

        should "should ignore the value type" do
          assert_equal Data.type(:string), subject.type
        end
      end

      context "when no type is specified" do
        should "cast types for Number, DateTime, Boolean, String" do
          assert_equal Data.type(:number), Data.new(12).type
          assert_equal Data.type(:number), Data.new(123.45).type
          assert_equal Data.type(:date_time), Data.new(Time.now).type
          assert_equal Data.type(:boolean), Data.new(true).type
          assert_equal Data.type(:boolean), Data.new(false).type
          assert_equal Data.type(:string), Data.new("a string").type
          assert_equal Data.type(:string), Data.new(:symbol).type
        end
      end

      context "for generating XML" do
        should_have_reader :xml
        should_build_node
      end

    end

  end
end

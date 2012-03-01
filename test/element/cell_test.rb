require "assert"
require 'enumeration/assert_macros'

require 'xmlss/element/cell'

module Xmlss::Element

  class CellTests < Assert::Context
    include Enumeration::AssertMacros

    desc "Xmlss::Cell"
    before { @c = Cell.new }
    subject { @c }

    should be_styled
    should have_class_method :writer
    should have_accessor :index, :formula, :href, :merge_across, :merge_down
    should have_reader :h_ref

    should have_enum :type, {
      :number => "Number",
      :date_time => "DateTime",
      :boolean => "Boolean",
      :string => "String",
      :error => "Error"
    }

    should have_accessor :data
    should have_instance_method :data_xml_value

    should "know its writer hook" do
      assert_equal :cell, subject.class.writer
    end

    should "set it's defaults" do
      assert_nil subject.formula
      assert_nil subject.href
      assert_nil subject.merge_across
      assert_nil subject.merge_down

      assert_equal Cell.type(:string), subject.type
      assert_equal "", subject.data
    end

    should "provide alias for :href" do
      c = Cell.new({:href => "http://www.google.com"})
      assert_equal "http://www.google.com", c.href
      assert_equal "http://www.google.com", c.h_ref
    end

    should "bark when setting non Fixnum indices" do
      assert_raises ArgumentError do
        Cell.new({:index => "do it"})
      end
      assert_raises ArgumentError do
        Cell.new({:index => 2.5})
      end
      assert_nothing_raised do
        Cell.new({:index => 2})
      end
    end

    should "bark when setting non Fixnum merge attrs" do
      assert_raises ArgumentError do
        Cell.new({:merge_across => "do it"})
      end
      assert_raises ArgumentError do
        Cell.new({:merge_down => 2.5})
      end
      assert_nothing_raised do
        Cell.new({:merge_across => 2})
      end
      assert_nothing_raised do
        Cell.new({:merge_down => 3})
      end
    end

    should "nil out merge/index values that are <= 0" do
      [:index, :merge_across, :merge_down].each do |a|
        assert_equal nil, Cell.new({a => -1}).send(a)
        assert_equal nil, Cell.new({a => 0}).send(a)
        assert_equal 1, Cell.new({a => 1}).send(a)
      end
    end

    should "generate it's data xml value" do
      assert_equal "12", Cell.new(12).data_xml_value
      assert_equal "string", Cell.new(:data => "string").data_xml_value
      assert_equal "2011-03-01T00:00:00", Cell.new(DateTime.parse('2011/03/01')).data_xml_value
      assert_equal "2011-03-01T00:00:00", Cell.new(Date.parse('2011/03/01')).data_xml_value
      time = Time.now
      assert_equal time.strftime("%Y-%m-%dT%H:%M:%S"), Cell.new(time).data_xml_value
    end

  end

  class ExplicitDataTest < CellTests
    desc "when using explicit data type"
    subject do
      Cell.new(12, {:type => :string})
    end

    should "should ignore the data value's implied type" do
      assert_equal Cell.type(:string), subject.type
    end

  end

  class NoTypeDataTest < CellTests
    desc "when no data type is specified"

    should "cast types for Number, DateTime, Boolean, String" do
      assert_equal Cell.type(:number), Cell.new(12).type
      assert_equal Cell.type(:number), Cell.new(:data => 123.45).type
      assert_equal Cell.type(:date_time), Cell.new(Time.now).type
      assert_equal Cell.type(:boolean), Cell.new(true).type
      assert_equal Cell.type(:boolean), Cell.new(false).type
      assert_equal Cell.type(:string), Cell.new("a string").type
      assert_equal Cell.type(:string), Cell.new(:data => :symbol).type
    end

  end

end

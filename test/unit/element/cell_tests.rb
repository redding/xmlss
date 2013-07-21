require "assert"
require 'xmlss/element/cell'

require 'enumeration/assert_macros'

class Xmlss::Element::Cell

  class CellTests < Assert::Context
    include Enumeration::AssertMacros

    desc "Xmlss::Element::Cell"
    before { @c = Xmlss::Element::Cell.new }
    subject { @c }

    should be_styled
    should have_class_method :writer
    should have_accessor :index, :formula, :href, :merge_across, :merge_down

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

      assert_equal Xmlss::Element::Cell.type(:string), subject.type
      assert_equal "", subject.data
    end

    should "bark when setting non Fixnum indices" do
      assert_raises ArgumentError do
        Xmlss::Element::Cell.new({:index => "do it"})
      end

      assert_raises ArgumentError do
        Xmlss::Element::Cell.new({:index => 2.5})
      end

      assert_nothing_raised do
        Xmlss::Element::Cell.new({:index => 2})
      end
    end

    should "bark when setting non Fixnum merge attrs" do
      assert_raises ArgumentError do
        Xmlss::Element::Cell.new({:merge_across => "do it"})
      end

      assert_raises ArgumentError do
        Xmlss::Element::Cell.new({:merge_down => 2.5})
      end

      assert_nothing_raised do
        Xmlss::Element::Cell.new({:merge_across => 2})
      end

      assert_nothing_raised do
        Xmlss::Element::Cell.new({:merge_down => 3})
      end
    end

    should "nil out merge/index values that are <= 0" do
      [:index, :merge_across, :merge_down].each do |a|
        assert_equal nil, Xmlss::Element::Cell.new({a => -1}).send(a)
        assert_equal nil, Xmlss::Element::Cell.new({a => 0}).send(a)
        assert_equal 1,   Xmlss::Element::Cell.new({a => 1}).send(a)
      end
    end

    should "generate it's data xml value" do
      assert_equal "12", Xmlss::Element::Cell.new(12).data_xml_value
      assert_equal "string", Xmlss::Element::Cell.new(:data => "string").data_xml_value
      assert_equal "2011-03-01T00:00:00", Xmlss::Element::Cell.new(DateTime.parse('2011/03/01')).data_xml_value
      assert_equal "2011-03-01T00:00:00", Xmlss::Element::Cell.new(Date.parse('2011/03/01')).data_xml_value
      time = Time.now
      assert_equal time.strftime("%Y-%m-%dT%H:%M:%S"), Xmlss::Element::Cell.new(time).data_xml_value
      assert_equal 1, Xmlss::Element::Cell.new(true).data_xml_value
      assert_equal 0, Xmlss::Element::Cell.new(false).data_xml_value
    end

  end

  class ExplicitDataTest < CellTests
    desc "when using explicit data type"
    subject do
      Xmlss::Element::Cell.new(12, {:type => :string})
    end

    should "should ignore the data value's implied type" do
      assert_equal Xmlss::Element::Cell.type(:string), subject.type
    end

  end

  class NoTypeDataTest < CellTests
    desc "when no data type is specified"

    should "cast types for Number, DateTime, Boolean, String" do
      assert_equal Xmlss::Element::Cell.type(:number),    Xmlss::Element::Cell.new(12).type
      assert_equal Xmlss::Element::Cell.type(:number),    Xmlss::Element::Cell.new(:data => 123.45).type
      assert_equal Xmlss::Element::Cell.type(:date_time), Xmlss::Element::Cell.new(Time.now).type
      assert_equal Xmlss::Element::Cell.type(:boolean),   Xmlss::Element::Cell.new(true).type
      assert_equal Xmlss::Element::Cell.type(:boolean),   Xmlss::Element::Cell.new(false).type
      assert_equal Xmlss::Element::Cell.type(:string),    Xmlss::Element::Cell.new("a string").type
      assert_equal Xmlss::Element::Cell.type(:string),    Xmlss::Element::Cell.new(:data => :symbol).type
    end

  end

end

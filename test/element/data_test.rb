require "assert"
require 'enumeration/assert_macros'

require 'xmlss/element/data'

module Xmlss::Element
  class DataTest < Assert::Context
    include Enumeration::AssertMacros

    desc "Xmlss::Data"
    subject { Data.new }

    should have_enum :type, {
      :number => "Number",
      :date_time => "DateTime",
      :boolean => "Boolean",
      :string => "String",
      :error => "Error"
    }

    should have_accessor :value
    should have_instance_method :xml_value

    should "set it's defaults" do
      assert_equal Data.type(:string), subject.type
      assert_equal "", subject.value
    end

    should "generate it's xml value" do
      assert_equal "12", Data.new(12).xml_value
      assert_equal "string", Data.new("string").xml_value
      assert_equal "line#{Data::LB}break", Data.new("line\nbreak").xml_value
      assert_equal "return#{Data::LB}break", Data.new("return\rbreak").xml_value
      assert_equal "returnline#{Data::LB}break", Data.new("returnline\r\nbreak").xml_value
      assert_equal "2011-03-01T00:00:00", Data.new(DateTime.parse('2011/03/01')).xml_value
      assert_equal "2011-03-01T00:00:00", Data.new(Date.parse('2011/03/01')).xml_value
      time = Time.now
      assert_equal time.strftime("%Y-%m-%dT%H:%M:%S"), Data.new(time).xml_value
    end

  end

  class ExplicitDataTest < DataTest
    desc "when using explicit type"
    subject do
      Data.new(12, {:type => :string})
    end

    should "should ignore the value type" do
      assert_equal Data.type(:string), subject.type
    end

  end

  class NoTypeDataTest < DataTest
    desc "when no type is specified"

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

  class WhitespaceDataTest < DataTest
    desc "dealing with line breaks and leading space"
    subject do
      Data.new(%s{
Should
  honor
    this
      })
    end

    should "honor them when generating xml" do
      reg = /#{Data::LB}Should#{Data::LB}\s{2}honor#{Data::LB}\s{4}this#{Data::LB}/
      assert_match reg, subject.xml_value
    end

  end

end

require "assert"
require 'test/thing'

module Xmlss
  class XmlTest < Assert::Context
    desc "Xmlss::Xml"
    before { @thing = Thing.new }
    subject { @thing }

    should "should provide proper namespace constants" do
      assert_equal "xmlns", Xmlss::XML_NS
      assert_equal "ss", Xmlss::SHEET_NS
      assert_equal "urn:schemas-microsoft-com:office:spreadsheet", Xmlss::NS_URI
    end

    should "bark if you use xml generation without configuring" do
      assert_raises ArgumentError do
        subject.build_xml
      end
    end

  end

  class XmlConfigTest < XmlTest
    desc "with config"
    before do
      subject.xml = {
        :node => :thing,
        :attributes => [:one, :two, :three],
        :children => [:child_nodes]
      }
      subject.one = true
      subject.two = "two"
      subject.three = ""
    end

    should "build it's xml" do
      assert_nothing_raised do
        subject.build_xml
      end
    end

    should "build with no whitespace formatting by default" do
      assert_equal(
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Thing ss:One=\"1\" ss:Two=\"two\"><Nodes /></Thing>",
        subject.build_xml
      )
    end

    should "build with whitespace formatting if specified" do
      assert_equal(
        "\n<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Thing ss:One=\"1\" ss:Two=\"two\">\n  <Nodes />\n</Thing>",
        subject.build_xml(:pp => 2)
      )
    end

    should "generate build attributes based on it's own attributes" do
      assert_nothing_raised do
        subject.send :build_attributes
      end
      attrs = subject.send :build_attributes

      assert_kind_of ::Hash, attrs
      assert attrs.has_key?("#{Xmlss::SHEET_NS}:One")
      assert_equal 1, attrs["#{Xmlss::SHEET_NS}:One"]
      assert attrs.has_key?("#{Xmlss::SHEET_NS}:Two")
      assert_equal 'two', attrs["#{Xmlss::SHEET_NS}:Two"]
      assert !attrs.has_key?("#{Xmlss::SHEET_NS}:Three")
    end

  end

end

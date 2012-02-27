require "assert"

require 'xmlss/element/worksheet'

module Xmlss::Element
  class WorksheetTest < Assert::Context
    desc "Xmlss::Worksheet"
    before { @wksht = Worksheet.new('sheet') }
    subject { @wksht }

    should have_accessor :name
    should have_instance_method :xml_attributes

    should "set it's defaults" do
      assert_equal 'sheet', subject.name
    end

    should "know its xml attributes" do
      assert_equal [:name], subject.xml_attributes
    end

    should "filter name chars" do
      # worksheet name cannot contain: /, \, :, ;, * or start with '['
      assert_equal "test test", Worksheet.new("test/ test").name
      assert_equal "test test", Worksheet.new("tes\\t test").name
      assert_equal "test test", Worksheet.new("te:st test:").name
      ws = Worksheet.new("te;st ;test")
      assert_equal "test test", ws.name
      ws.name = "t*est test"
      assert_equal "test test", ws.name
      ws.name = "[te]st test"
      assert_equal "te]st test", ws.name
      ws.name = "t[e]st test"
      assert_equal "t[e]st test", ws.name
    end

  end

end

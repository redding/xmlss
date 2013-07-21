require "assert"
require 'xmlss/element/worksheet'

class Xmlss::Element::Worksheet

  class UnitTests < Assert::Context
    desc "Xmlss::Element::Worksheet"
    before { @wksht = Xmlss::Element::Worksheet.new('sheet') }
    subject { @wksht }

    should have_class_method :writer
    should have_accessor :name

    should "know its writer hook" do
      assert_equal :worksheet, subject.class.writer
    end

    should "set it's defaults" do
      assert_equal 'sheet', subject.name
    end

    should "filter name chars" do
      # worksheet name cannot contain: /, \, :, ;, * or start with '['
      assert_equal "test test", Xmlss::Element::Worksheet.new("test/ test").name
      assert_equal "test test", Xmlss::Element::Worksheet.new("tes\\t test").name
      assert_equal "test test", Xmlss::Element::Worksheet.new("te:st test:").name

      ws = Xmlss::Element::Worksheet.new("te;st ;test")
      assert_equal "test test", ws.name

      ws.name = "t*est test"
      assert_equal "test test", ws.name

      ws.name = "[te]st test"
      assert_equal "te]st test", ws.name

      ws.name = "t[e]st test"
      assert_equal "t[e]st test", ws.name
    end

    should "complain if given a name longer than 31 chars" do
      assert_raises ArgumentError do
        Xmlss::Element::Worksheet.new('a'*32)
      end

      assert_nothing_raised do
        Xmlss::Element::Worksheet.new('a'*31)
      end
    end

  end

end

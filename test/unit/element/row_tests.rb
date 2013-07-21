require "assert"
require 'xmlss/element/row'

class Xmlss::Element::Row

  class UnitTests < Assert::Context
    desc "Xmlss::Element::Row"
    before { @row = Xmlss::Element::Row.new }
    subject { @row }

    should be_styled
    should have_class_method :writer
    should have_accessors :height, :auto_fit_height, :autofit, :hidden
    should have_readers   :autofit?, :hidden?

    should "know its writer hook" do
      assert_equal :row, subject.class.writer
    end

    should "set it's defaults" do
      assert_nil subject.height
      assert_equal false, subject.auto_fit_height
      assert_equal false, subject.hidden
    end

    should "bark when setting non Numeric height" do
      assert_raises ArgumentError do
        Xmlss::Element::Row.new({:height => "do it"})
      end

      assert_nothing_raised do
        Xmlss::Element::Row.new({:height => 2})
      end

      assert_nothing_raised do
        Xmlss::Element::Row.new({:height => 3.5})
      end
    end

    should "nil out height values that are < 0" do
      assert_equal nil, Xmlss::Element::Row.new({:height => -1.2}).height
      assert_equal nil, Xmlss::Element::Row.new({:height => -1}).height
      assert_equal 0,   Xmlss::Element::Row.new({:height => 0}).height
      assert_equal 1.2, Xmlss::Element::Row.new({:height => 1.2}).height
    end
  end

end

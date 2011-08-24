require "assert"
require 'xmlss/cell'
require 'xmlss/row'

module Xmlss
  class RowTest < Assert::Context
    desc "Xmlss::Row"
    before { @row = Row.new }
    subject { @row }

    should_have_style(Row)
    should have_accessors :height, :auto_fit_height, :hidden
    should have_accessor :cells

    should "set it's defaults" do
      assert_equal nil, subject.height
      assert_equal false, subject.auto_fit_height
      assert_equal false, subject.hidden
      assert_equal [], subject.cells
    end

    should "allow defining a cells at init" do
      row = Row.new({
        :cells => [Cell.new]
      })

      assert_equal 1, row.cells.size
      assert_kind_of Cell, row.cells.first
    end

    should "bark when setting non Numeric height" do
      assert_raises ArgumentError do
        Row.new({:height => "do it"})
      end
      assert_nothing_raised do
        Row.new({:height => 2})
      end
      assert_nothing_raised do
        Row.new({:height => 3.5})
      end
    end

    should "nil out height values that are < 0" do
      assert_equal nil, Row.new({:height => -1.2}).height
      assert_equal nil, Row.new({:height => -1}).height
      assert_equal 0, Row.new({:height => 0}).height
      assert_equal 1.2, Row.new({:height => 1.2}).height
    end
  end

  class RowCellsTest < RowTest
    desc "when using cells"
    before do
      r = subject.cells << Cell.new
    end

    should "should build a data object" do
      assert_equal 1, subject.cells.size
      assert_kind_of Cell, subject.cells.first
    end
  end

  class RowXmlTest < RowTest
    desc "for generating XML"

    should have_reader :xml
    should_build_node
  end

end

require "test/helper"
require 'xmlss/row'

module Xmlss
  class RowTest < Test::Unit::TestCase

    context "Xmlss::Row" do
      subject { Row.new }

      should_have_style(Row)
      should_have_accessor :height, :auto_fit_height, :hidden
      should_have_accessor :cells

      should "set it's defaults" do
        assert_equal nil, subject.height
        assert_equal false, subject.auto_fit_height
        assert_equal false, subject.hidden
        assert_equal [], subject.cells
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


      context "when using cells" do
        before { subject.cells << Cell.new }

        should "should build a data object" do
          puts subject.to_xml
          assert_equal 1, subject.cells.size
          assert_kind_of Cell, subject.cells.first
        end
      end

      context "for generating XML" do
        should_have_reader :xml
        should_build_node
      end

    end

  end
end

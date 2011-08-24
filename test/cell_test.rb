require "assert"
require 'xmlss/cell'

module Xmlss
  class CellTest < Assert::Context
    desc "Xmlss::Cell"
    subject { Cell.new }

    should have_accessor :index, :data
    should have_accessor :formula, :href, :merge_across, :merge_down
    should have_reader :h_ref

    should_have_style(Cell)

    should "set it's defaults" do
      [:data, :formula, :href].each do |a|
        assert_equal nil, subject.send(a)
      end
      assert_equal nil, subject.merge_across
      assert_equal nil, subject.merge_down
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

  end

  class CellDataTest < Assert::Context
    desc "when using cell data"
    subject do
      Cell.new({
        :data => Data.new(12, {:type => :number})
      })
    end

    should "should build a data object" do
      assert_kind_of Data, subject.data
      assert_equal 12, subject.data.value
    end

  end

  class CellDataXmlTest < CellDataTest
    desc "for generating XML"

    should have_reader :xml
    should_build_node

  end

end

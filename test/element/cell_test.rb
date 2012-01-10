require "assert"

require 'xmlss/element/cell'

module Xmlss::Element
  class CellTest < Assert::Context
    desc "Xmlss::Cell"
    before { @c = Cell.new }
    subject { @c }

    should be_styled
    should have_accessor :index, :formula, :href, :merge_across, :merge_down
    should have_reader :h_ref

    should "set it's defaults" do
      assert_nil subject.formula
      assert_nil subject.href
      assert_nil subject.merge_across
      assert_nil subject.merge_down
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

end

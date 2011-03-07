require "test/helper"
require 'xmlss/cell'

module Xmlss
  class DataTest < Test::Unit::TestCase

    context "Xmlss::Cell" do
      subject { Cell.new }

      should_have_accessor :index, :style_id
      should_have_accessor :formula, :href, :merge_across, :merge_down
      should_have_accessor :comment, :data
      should_have_reader :h_ref, :style_i_d

      should "set it's defaults" do
        [:index, :style_id, :data, :comment, :formula, :href].each do |a|
          assert_equal nil, subject.send(a)
        end
        assert_equal 0, subject.merge_across
        assert_equal 0, subject.merge_down
      end

      should "provide aliases for style_id and :href" do
        c = Cell.new({:style_id => :poo, :href => "http://www.google.com"})
        assert_equal :poo, c.style_id
        assert_equal :poo, c.style_i_d
        assert_equal "http://www.google.com", c.h_ref
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

      context "when using cell data" do
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

      context "for generating XML" do
        should_have_reader :xml
        should_build_node
      end

    end

  end
end

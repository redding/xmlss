require "assert"
require 'enumeration/assert_macros'

require 'xmlss/style/border'

module Xmlss::Style
  class BorderTest < Assert::Context
    include Enumeration::AssertMacros

    desc "Xmlss::Style::Border"
    before { @b = Xmlss::Style::Border.new }
    subject { @b }

    should have_enum :position, {
      :left => "Left",
      :top => "Top",
      :right => "Right",
      :bottom => "Bottom",
      :diagonal_left => "DiagonalLeft",
      :diagonal_right => "DiagonalRight"
    }

    should have_enum :weight, {
      :hairline => 0,
      :thin => 1,
      :medium => 2,
      :thick => 3
    }

    should have_enum :line_style, {
      :none => "None",
      :continuous => "Continuous",
      :dash => "Dash",
      :dot => "Dot",
      :dash_dot => "DashDot",
      :dash_dot_dot => "DashDotDot"
    }


    should have_accessors :color

    should "set it's defaults" do
      assert_equal nil, subject.color
      assert_equal nil, subject.position
      assert_equal Border.weight(:thin), subject.weight
      assert_equal Border.line_style(:continuous), subject.line_style
    end

    should "set attrs at init" do
      attrs = {
        :color => '#FF0000',
        :position => :top,
        :weight => :thick,
        :line_style => :dot
      }
      border = Border.new(attrs)

      attrs.reject{|a, v| [:position, :weight, :line_style].include?(a)}.each do |a,v|
        assert_equal v, border.send(a)
      end
      assert_equal Border.position(:top), border.position
      assert_equal Border.weight(:thick), border.weight
      assert_equal Border.line_style(:dot), border.line_style
    end

    should "set attrs by key" do
      subject.position = :bottom
      subject.weight = :medium
      subject.line_style = :dash_dot

      assert_equal Border.position(:bottom), subject.position
      assert_equal Border.weight(:medium), subject.weight
      assert_equal Border.line_style(:dash_dot), subject.line_style
    end

    should "set attrs by value" do
      subject.position = Border.position(:bottom)
      subject.weight = Border.weight(:medium)
      subject.line_style = Border.line_style(:dash_dot)

      assert_equal Border.position(:bottom), subject.position
      assert_equal Border.weight(:medium), subject.weight
      assert_equal Border.line_style(:dash_dot), subject.line_style
    end

  end

end

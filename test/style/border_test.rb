require "test/helper"
require 'xmlss/style/border'

class Xmlss::Style::BorderTest < Test::Unit::TestCase

  context "Xmlss::Style::Border" do
    subject { Xmlss::Style::Border.new }

    should_have_class_method :position
    {
      :left => "Left",
      :top => "Top",
      :right => "Right",
      :bottom => "Bottom",
      :diagonal_left => "DiagonalLeft",
      :diagonal_right => "DiagonalRight"
    }.each do |position, value|
      should "provide the value for the '#{position}' position" do
        assert_equal value, Xmlss::Style::Border.position(position)
      end
    end

    should_have_class_method :weight
    {
      :hairline => 0,
      :thin => 1,
      :medium => 2,
      :thick => 3
    }.each do |weight, value|
      should "provide the value for the '#{weight}' weight" do
        assert_equal value, Xmlss::Style::Border.weight(weight)
      end
    end

    should_have_class_method :line_style
    {
      :none => "None",
      :continuous => "Continuous",
      :dash => "Dash",
      :dot => "Dot",
      :dash_dot => "DashDot",
      :dash_dot_dot => "DashDotDot"
    }.each do |style, value|
      should "provide the value for the '#{style}' line_style" do
        assert_equal value, Xmlss::Style::Border.line_style(style)
      end
    end

    should_have_accessors :color, :position, :weight, :line_style

    should "set it's defaults" do
      assert_equal nil, subject.color
      assert_equal nil, subject.position
      assert_equal Xmlss::Style::Border.weight(:thin), subject.weight
      assert_equal Xmlss::Style::Border.line_style(:continuous), subject.line_style
    end

    context "that sets attributes at init" do
      before do
        @attrs = {
          :color => '#FF0000',
          :position => :top,
          :weight => :thick,
          :line_style => :dot
        }
        @border = Xmlss::Style::Border.new(@attrs)
      end
      subject{ @border }

      should "should set them correctly" do
        @attrs.reject{|a, v| [:position, :weight, :line_style].include?(a)}.each do |a,v|
          assert_equal v, subject.send(a)
        end
        assert_equal Xmlss::Style::Border.position(:top), subject.position
        assert_equal Xmlss::Style::Border.weight(:thick), subject.weight
        assert_equal Xmlss::Style::Border.line_style(:dot), subject.line_style
      end
    end

    context "that sets position, weight, and style by key" do
      before do
        subject.position = :bottom
        subject.weight = :medium
        subject.line_style = :dash_dot
      end

      should "should returm it by value" do
        assert_equal Xmlss::Style::Border.position(:bottom), subject.position
        assert_equal Xmlss::Style::Border.weight(:medium), subject.weight
        assert_equal Xmlss::Style::Border.line_style(:dash_dot), subject.line_style
      end
    end

    context "that sets position, weight, and style by value" do
      before do
        subject.position = Xmlss::Style::Border.position(:bottom)
        subject.weight = Xmlss::Style::Border.weight(:medium)
        subject.line_style = Xmlss::Style::Border.line_style(:dash_dot)
      end

      should "should returm it by value" do
        assert_equal Xmlss::Style::Border.position(:bottom), subject.position
        assert_equal Xmlss::Style::Border.weight(:medium), subject.weight
        assert_equal Xmlss::Style::Border.line_style(:dash_dot), subject.line_style
      end
    end

    context "for generating XML" do
      should_have_reader :xml
      should_build_node
    end

  end
end

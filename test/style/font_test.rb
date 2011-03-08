require "test/helper"
require 'xmlss/style/font'

class Xmlss::Style::FontTest < Test::Unit::TestCase

  context "Xmlss::Style::Font" do
    subject { Xmlss::Style::Font.new }

    should_have_class_method :underline
    {
      :none => 0,
      :single => 1,
      :double => 2
    }.each do |underline, value|
      should "provide the value for the '#{underline}' underline" do
        assert_equal value, Xmlss::Style::Font.underline(underline)
      end
    end

    should_have_class_method :alignment
    {
      :none => 0,
      :subscript => 1,
      :superscript => 2
    }.each do |alignment, value|
      should "provide the value for the '#{alignment}' alignment" do
        assert_equal value, Xmlss::Style::Font.alignment(alignment)
      end
    end

    should_have_accessors :bold, :color, :italic, :size, :strike_through
    should_have_accessors :underline, :alignment
    should_have_instance_methods :bold?, :italic?, :strike_through?

    should "set it's defaults" do
      assert_equal false, subject.bold
      assert_equal nil, subject.color
      assert_equal false, subject.italic
      assert_equal nil, subject.size
      assert_equal false, subject.strike_through
      assert_equal Xmlss::Style::Font.underline(:default), subject.underline
      assert_equal Xmlss::Style::Font.alignment(:default), subject.alignment
    end

    context "that sets attributes at init" do
      before do
        @attrs = {
          :bold => true,
          :color => '#FF0000',
          :italic => true,
          :size => 10,
          :strike_through => true,
          :underline => :single,
          :alignment => :superscript
        }
        @font = Xmlss::Style::Font.new(@attrs)
      end
      subject{ @font }

      should "should set them correctly" do
        @attrs.reject{|a, v| [:underline, :alignment].include?(a)}.each do |a,v|
          assert_equal v, subject.send(a)
        end
        assert_equal Xmlss::Style::Font.underline(:single), subject.underline
        assert_equal Xmlss::Style::Font.alignment(:superscript), subject.alignment
      end
    end

    context "that sets underline and alignment by key" do
      before do
        subject.underline = :double
        subject.alignment = :subscript
      end

      should "should returm it by value" do
        assert_equal Xmlss::Style::Font.underline(:double), subject.underline
        assert_equal Xmlss::Style::Font.alignment(:subscript), subject.alignment
      end
    end

    context "that sets underline and alignment by value" do
      before do
        subject.underline = Xmlss::Style::Font.underline(:double)
        subject.alignment = Xmlss::Style::Font.alignment(:subscript)
      end

      should "should returm it by value" do
        assert_equal Xmlss::Style::Font.underline(:double), subject.underline
        assert_equal Xmlss::Style::Font.alignment(:subscript), subject.alignment
      end
    end

    context "for generating XML" do
      should_have_reader :xml
      should_build_node
      should_build_no_attributes_by_default(Xmlss::Style::Font)
    end

  end
end

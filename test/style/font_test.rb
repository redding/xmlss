require "assert"
require 'xmlss/style/font'

module Xmlss::Style
  class FontTest < Assert::Context
    desc "Xmlss::Style::Font"
    before { @f = Font.new }
    subject { @f }

    should have_class_method :underline

    {
      :single => 'Single',
      :double => 'Double',
      :single_accounting => 'SingleAccounting',
      :double_accounting => 'DoubleAccounting'
    }.each do |underline, value|
      should "provide the value for the '#{underline}' underline" do
        assert_equal value, Xmlss::Style::Font.underline(underline)
      end
    end

    should have_class_method :alignment

    {
      :subscript => 'Subscript',
      :superscript => 'Superscript'
    }.each do |alignment, value|
      should "provide the value for the '#{alignment}' alignment" do
        assert_equal value, Xmlss::Style::Font.alignment(alignment)
      end
    end

    should have_accessors :bold, :color, :italic, :size, :strike_through, :shadow
    should have_accessors :underline, :alignment, :name
    should have_instance_methods :bold?, :italic?, :strike_through?, :shadow?
    should have_reader :vertical_align

    should "set it's defaults" do
      assert_equal false, subject.bold
      assert_equal nil, subject.color
      assert_equal false, subject.italic
      assert_equal nil, subject.size
      assert_equal false, subject.strike_through
      assert_equal false, subject.shadow
      assert_equal nil, subject.underline
      assert_equal nil, subject.alignment
      assert_equal nil, subject.name
    end

    should "set attrs at init" do
      attrs = {
        :bold => true,
        :color => '#FF0000',
        :italic => true,
        :size => 10,
        :strike_through => true,
        :underline => :single,
        :alignment => :superscript,
        :name => 'Verdana'
      }
      font = Font.new(attrs)

      attrs.reject{|a, v| [:underline, :alignment].include?(a)}.each do |a,v|
        assert_equal v, font.send(a)
      end
      assert_equal Font.underline(:single), font.underline
      assert_equal Font.alignment(:superscript), font.alignment
    end

    should "set attrs by key" do
      subject.underline = :double
      subject.alignment = :subscript

      assert_equal Font.underline(:double), subject.underline
      assert_equal Font.alignment(:subscript), subject.alignment
    end

    should "set attrs by value" do
      subject.underline = Xmlss::Style::Font.underline(:double)
      subject.alignment = Xmlss::Style::Font.alignment(:subscript)

      assert_equal Xmlss::Style::Font.underline(:double), subject.underline
      assert_equal Xmlss::Style::Font.alignment(:subscript), subject.alignment
    end

  end

  class FontXmlTest < FontTest
    desc "for generating XML"

    should have_reader :xml
    should_build_node
    should_build_no_attributes_by_default(Xmlss::Style::Font)
  end

end

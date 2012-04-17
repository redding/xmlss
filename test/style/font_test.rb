require "assert"
require 'enumeration/assert_macros'

require 'xmlss/style/font'

module Xmlss::Style
  class FontTest < Assert::Context
    include Enumeration::AssertMacros

    desc "Xmlss::Style::Font"
    before { @f = Font.new }
    subject { @f }

    should have_enum :underline, {
      :single => 'Single',
      :double => 'Double',
      :single_accounting => 'SingleAccounting',
      :double_accounting => 'DoubleAccounting'
    }

    should have_enum :alignment, {
      :subscript => 'Subscript',
      :superscript => 'Superscript'
    }

    should have_class_method :writer
    should have_accessors :bold, :color, :italic, :size, :strike_through
    should have_accessors :shadow, :underline, :alignment, :name
    should have_instance_methods :bold?, :italic?, :strike_through?, :shadow?

    should "know its writer" do
      assert_equal :font, subject.class.writer
    end

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

  end

end

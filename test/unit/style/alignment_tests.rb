require "assert"
require 'xmlss/style/alignment'

require 'enumeration/assert_macros'

class Xmlss::Style::Alignment

  class UnitTests < Assert::Context
    include Enumeration::AssertMacros

    desc "Xmlss::Style::Alignment"
    before { @a = Xmlss::Style::Alignment.new }
    subject { @a }

    should have_enum :horizontal, {
      :automatic => "Automatic",
      :left => "Left",
      :center => "Center",
      :right => "Right"
    }

    should have_enum :vertical, {
      :automatic => "Automatic",
      :top => "Top",
      :center => "Center",
      :bottom => "Bottom"
    }

    should have_class_method :writer
    should have_accessors :wrap_text, :rotate
    should have_instance_methods :wrap_text?

    should "know its writer" do
      assert_equal :alignment, subject.class.writer
    end

    should "set it's defaults" do
      assert_equal false, subject.wrap_text
      assert_equal nil,   subject.horizontal
      assert_equal nil,   subject.vertical
      assert_equal nil,   subject.rotate
    end

    should "reject invalid rotate alignments" do
      assert_equal nil, Xmlss::Style::Alignment.new({:rotate => 100}).rotate
      assert_equal 90,  Xmlss::Style::Alignment.new({:rotate => 90}).rotate
      assert_equal 0,   Xmlss::Style::Alignment.new({:rotate => 0}).rotate
      assert_equal -90, Xmlss::Style::Alignment.new({:rotate => -90}).rotate
      assert_equal nil, Xmlss::Style::Alignment.new({:rotate => -100}).rotate
      assert_equal 0,   Xmlss::Style::Alignment.new({:rotate => 0.2}).rotate
      assert_equal 1,   Xmlss::Style::Alignment.new({:rotate => 0.5}).rotate
      assert_equal nil, Xmlss::Style::Alignment.new({:rotate => "poo"}).rotate
      assert_equal nil, Xmlss::Style::Alignment.new({:rotate => :poo}).rotate
    end

    should "set build with values correctly" do
      attrs = {
        :wrap_text => true,
        :horizontal => :center,
        :vertical => :bottom,
        :rotate => 90
      }
      alignment = Xmlss::Style::Alignment.new(attrs)

      attrs.reject{|a, v| [:horizontal, :vertical].include?(a)}.each do |a,v|
        assert_equal v, alignment.send(a)
      end
      assert_equal Xmlss::Style::Alignment.horizontal(:center), alignment.horizontal
      assert_equal Xmlss::Style::Alignment.vertical(:bottom), alignment.vertical
    end

  end

end

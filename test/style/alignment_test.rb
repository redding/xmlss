require "assert"
require 'xmlss/style/alignment'

module Xmlss::Style
  class AlignmentTest < Assert::Context
    desc "Xmlss::Style::Alignment"
    before { @a = Alignment.new }
    subject { @a }

    should have_class_method :horizontal

    {
      :automatic => "Automatic",
      :left => "Left",
      :center => "Center",
      :right => "Right"
    }.each do |horizontal, value|
      should "provide the value for the '#{horizontal}' horizontal" do
        assert_equal value, Alignment.horizontal(horizontal)
      end
    end

    should have_class_method :vertical

    {
      :automatic => "Automatic",
      :top => "Top",
      :center => "Center",
      :bottom => "Bottom"
    }.each do |vertical, value|
      should "provide the value for the '#{vertical}' vertical" do
        assert_equal value, Alignment.vertical(vertical)
      end
    end

    should have_accessors :horizontal, :vertical, :wrap_text, :rotate
    should have_instance_methods :wrap_text?

    should "set it's defaults" do
      assert_equal false, subject.wrap_text
      assert_equal nil, subject.horizontal
      assert_equal nil, subject.vertical
      assert_equal nil, subject.rotate
    end

    should "reject invalid rotate alignments" do
      assert_equal nil, Alignment.new({:rotate => 100}).rotate
      assert_equal 90,  Alignment.new({:rotate => 90}).rotate
      assert_equal 0,   Alignment.new({:rotate => 0}).rotate
      assert_equal -90, Alignment.new({:rotate => -90}).rotate
      assert_equal nil, Alignment.new({:rotate => -100}).rotate
      assert_equal 0,   Alignment.new({:rotate => 0.2}).rotate
      assert_equal 1,   Alignment.new({:rotate => 0.5}).rotate
      assert_equal nil, Alignment.new({:rotate => "poo"}).rotate
      assert_equal nil, Alignment.new({:rotate => :poo}).rotate
    end

    should "should set them correctly" do
      attrs = {
        :wrap_text => true,
        :horizontal => :center,
        :vertical => :bottom,
        :rotate => 90
      }
      alignment = Alignment.new(attrs)

      attrs.reject{|a, v| [:horizontal, :vertical].include?(a)}.each do |a,v|
        assert_equal v, alignment.send(a)
      end
      assert_equal Alignment.horizontal(:center), alignment.horizontal
      assert_equal Alignment.vertical(:bottom), alignment.vertical
    end

    should "set attrs by key" do
      subject.horizontal = :left
      subject.vertical = :top

      assert_equal Alignment.horizontal(:left), subject.horizontal
      assert_equal Alignment.vertical(:top), subject.vertical
    end

    should "set attrs by value" do
      subject.horizontal = Alignment.horizontal(:right)
      subject.vertical = Alignment.vertical(:center)

      assert_equal Alignment.horizontal(:right), subject.horizontal
      assert_equal Alignment.vertical(:center), subject.vertical
    end

  end

  class AlignmentXmlTest < AlignmentTest
    desc "for generating XML"

    should have_reader :xml
    should_build_node
    should_build_no_attributes_by_default(Alignment)
  end

end

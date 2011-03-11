require "test/helper"
require 'xmlss/style/alignment'

class Xmlss::Style::AlignmentTest < Test::Unit::TestCase

  context "Xmlss::Style::Alignment" do
    subject { Xmlss::Style::Alignment.new }

    should_have_class_method :horizontal
    {
      :automatic => "Automatic",
      :left => "Left",
      :center => "Center",
      :right => "Right"
    }.each do |horizontal, value|
      should "provide the value for the '#{horizontal}' horizontal" do
        assert_equal value, Xmlss::Style::Alignment.horizontal(horizontal)
      end
    end

    should_have_class_method :vertical
    {
      :automatic => "Automatic",
      :top => "Top",
      :center => "Center",
      :bottom => "Bottom"
    }.each do |vertical, value|
      should "provide the value for the '#{vertical}' vertical" do
        assert_equal value, Xmlss::Style::Alignment.vertical(vertical)
      end
    end

    should_have_accessors :horizontal, :vertical, :wrap_text, :rotate
    should_have_instance_methods :wrap_text?

    should "set it's defaults" do
      assert_equal false, subject.wrap_text
      assert_equal nil, subject.horizontal
      assert_equal nil, subject.vertical
      assert_equal nil, subject.rotate
    end

    context "that sets attributes at init" do
      before do
        @attrs = {
          :wrap_text => true,
          :horizontal => :center,
          :vertical => :bottom,
          :rotate => 90
        }
        @alignment = Xmlss::Style::Alignment.new(@attrs)
      end
      subject{ @alignment }

      should "should set them correctly" do
        @attrs.reject{|a, v| [:horizontal, :vertical].include?(a)}.each do |a,v|
          assert_equal v, subject.send(a)
        end
        assert_equal Xmlss::Style::Alignment.horizontal(:center), subject.horizontal
        assert_equal Xmlss::Style::Alignment.vertical(:bottom), subject.vertical
      end
    end

    should "reject invalid rotate alignments" do
      assert_equal nil, Xmlss::Style::Alignment.new({:rotate => 100}).rotate
      assert_equal 90, Xmlss::Style::Alignment.new({:rotate => 90}).rotate
      assert_equal 0, Xmlss::Style::Alignment.new({:rotate => 0}).rotate
      assert_equal -90, Xmlss::Style::Alignment.new({:rotate => -90}).rotate
      assert_equal nil, Xmlss::Style::Alignment.new({:rotate => -100}).rotate
      assert_equal 0, Xmlss::Style::Alignment.new({:rotate => 0.2}).rotate
      assert_equal 1, Xmlss::Style::Alignment.new({:rotate => 0.5}).rotate
      assert_equal nil, Xmlss::Style::Alignment.new({:rotate => "poo"}).rotate
      assert_equal nil, Xmlss::Style::Alignment.new({:rotate => :poo}).rotate
    end

    context "that sets underline and alignment by key" do
      before do
        subject.horizontal = :left
        subject.vertical = :top
      end

      should "should returm it by value" do
        assert_equal Xmlss::Style::Alignment.horizontal(:left), subject.horizontal
        assert_equal Xmlss::Style::Alignment.vertical(:top), subject.vertical
      end
    end

    context "that sets underline and alignment by value" do
      before do
        subject.horizontal = Xmlss::Style::Alignment.horizontal(:right)
        subject.vertical = Xmlss::Style::Alignment.vertical(:center)
      end

      should "should returm it by value" do
        assert_equal Xmlss::Style::Alignment.horizontal(:right), subject.horizontal
        assert_equal Xmlss::Style::Alignment.vertical(:center), subject.vertical
      end
    end

    context "for generating XML" do
      should_have_reader :xml
      should_build_node
      should_build_no_attributes_by_default(Xmlss::Style::Alignment)
    end

  end
end

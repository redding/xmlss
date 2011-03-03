require "test/helper"
require 'xmlss/style/alignment'

class Xmlss::Style::AlignmentTest < Test::Unit::TestCase

  context "Xmlss::Style::Alignment" do
    subject { Xmlss::Style::Alignment.new }

    should_have_class_method :horizontal
    {
      :automatic => 0,
      :left => 1,
      :center => 2,
      :right => 3,
      :default => 4
    }.each do |horizontal, value|
      should "provide the value for the '#{horizontal}' horizontal" do
        assert_equal value, Xmlss::Style::Alignment.horizontal(horizontal)
      end
    end

    should_have_class_method :vertical
    {
      :automatic => 0,
      :top => 1,
      :center => 2,
      :bottom => 3,
      :default => 4
    }.each do |vertical, value|
      should "provide the value for the '#{vertical}' vertical" do
        assert_equal value, Xmlss::Style::Alignment.vertical(vertical)
      end
    end

    should_have_accessors :horizontal, :vertical, :wrap_text
    should_have_instance_methods :wrap_text?

    should "set it's defaults" do
      assert_equal false, subject.wrap_text
      assert_equal Xmlss::Style::Alignment.horizontal(:default), subject.horizontal
      assert_equal Xmlss::Style::Alignment.vertical(:default), subject.vertical
    end

    context "that sets attributes at init" do
      before do
        @attrs = {
          :wrap_text => true,
          :horizontal => :center,
          :vertical => :bottom
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

  end
end

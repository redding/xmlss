require "test/helper"
require 'xmlss/style/interior'

class Xmlss::Style::InteriorTest < Test::Unit::TestCase

  context "Xmlss::Style::Interior" do
    subject { Xmlss::Style::Interior.new }

    should_have_class_method :pattern
    {
      :one => 0,
      :solid => 1,
      :gray75 => 2,
      :gray50 => 3,
      :gray25 => 4,
      :gray125 => 5,
      :gray0625 => 6,
      :horz_stripe => 7,
      :vert_stripe => 8,
      :diag_stripe => 9,
      :diag_cross => 10,
      :reverseDiagStripe => 11,
      :thin_reverse_diag_stripe => 12,
      :thick_diag_cross => 13,
      :thin_diag_cross => 14,
      :thin_horz_stripe => 15,
      :thin_vert_stripe => 16,
      :thin_diag_strip => 17,
      :thin_horz_cross => 18
    }.each do |pattern, value|
      should "provide the value for the '#{pattern}' pattern" do
        assert_equal value, Xmlss::Style::Interior.pattern(pattern)
      end
    end

    should_have_accessor :color, :pattern, :pattern_color

    should "set it's defaults" do
      assert_equal nil, subject.color
      assert_equal nil, subject.pattern
      assert_equal nil, subject.pattern_color
    end

    context "that sets attributes at init" do
      subject do
        Xmlss::Style::Interior.new({
          :color => "#000000",
          :pattern => :solid,
          :pattern_color => "#FF0000"
        })
      end

      should "should set them correctly" do
        assert_equal "#000000", subject.color
        assert_equal 1, subject.pattern
        assert_equal "#FF0000", subject.pattern_color
      end
    end

    context "that sets pattern by key" do
      before do
        subject.pattern = :solid
      end

      should "should returm them by value" do
        assert_equal 1, subject.pattern
      end
    end

    context "that sets attributes by value" do
      before do
        subject.pattern = 1
      end

      should "should returm them by value" do
        assert_equal 1, subject.pattern
      end
    end

    context "for generating XML" do
      should_have_reader :xml
      should_build_node
      should_build_no_attributes_by_default(Xmlss::Style::Alignment)
    end

  end
end

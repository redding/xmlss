require "test/helper"
require 'xmlss/style/interior'

class Xmlss::Style::InteriorTest < Test::Unit::TestCase

  context "Xmlss::Style::Interior" do
    subject { Xmlss::Style::Interior.new }

    should_have_class_method :pattern
    {
      :none => "None",
      :solid => "Solid",
      :gray75 => "Gray75",
      :gray50 => "Gray50",
      :gray25 => "Gray25",
      :gray125 => "Gray125",
      :gray0625 => "Gray0625",
      :horz_stripe => "HorzStripe",
      :vert_stripe => "VertStripe",
      :reverse_diag_stripe => "ReverseDiagStripe",
      :diag_stripe => "DiagStripe",
      :diag_cross => "DiagCross",
      :thick_diag_cross => "ThickDiagCross",
      :thin_horz_stripe => "ThinHorzStripe",
      :thin_vert_stripe => "ThinVertStripe",
      :thin_reverse_diag_stripe => "ThinReverseDiagStripe",
      :thin_diag_stripe => "ThineDiagStripe",
      :thin_horz_cross => "ThinHorzCross",
      :thin_diag_cross => "ThinDiagCross"
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
        assert_equal "Solid", subject.pattern
        assert_equal "#FF0000", subject.pattern_color
      end
    end

    context "that sets pattern by key" do
      before do
        subject.pattern = :solid
      end

      should "should returm them by value" do
        assert_equal "Solid", subject.pattern
      end
    end

    context "that sets attributes by value" do
      before do
        subject.pattern = "Solid"
      end

      should "should returm them by value" do
        assert_equal "Solid", subject.pattern
      end
    end

    context "for generating XML" do
      should_have_reader :xml
      should_build_node
      should_build_no_attributes_by_default(Xmlss::Style::Alignment)
    end

  end
end

require "assert"
require 'xmlss/style/interior'

module Xmlss::Style

  class InteriorTest < Assert::Context
    desc "Xmlss::Style::Interior"
    before { @i = Interior.new }
    subject { @i }

    should have_class_method :pattern

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

    should have_accessor :color, :pattern, :pattern_color

    should "set it's defaults" do
      assert_equal nil, subject.color
      assert_equal nil, subject.pattern
      assert_equal nil, subject.pattern_color
    end

    should "set attributes at init" do
      i = Interior.new({
        :color => "#000000",
        :pattern => :solid,
        :pattern_color => "#FF0000"
      })
      assert_equal "#000000", i.color
      assert_equal "Solid", i.pattern
      assert_equal "#FF0000", i.pattern_color
    end

    should "set attrs by key" do
      subject.pattern = :solid
      assert_equal "Solid", subject.pattern
    end

    should "set attrs by value" do
      subject.pattern = "Solid"
      assert_equal "Solid", subject.pattern
    end

  end

  class InteriorXmlTest < InteriorTest
    desc "for generating XML"

    should have_reader :xml
    should_build_xml
    should_build_no_attributes_by_default(Xmlss::Style::Alignment)
  end

end

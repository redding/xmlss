require "assert"
require 'xmlss/style/number_format'

module Xmlss::Style
  class NumberFormatTest < Assert::Context
    desc "Xmlss::Style::NumberFormat"
    before { @nf = NumberFormat.new }
    subject { @nf }

    should have_accessor :format

    should "set attributes at init" do
      nf = Xmlss::Style::NumberFormat.new({
        :format => "General"
      })
      assert_equal "General", nf.format
    end

    should "set format by key" do
      subject.format = "@"
      assert_equal "@", subject.format
    end

    should "set format by value" do
      subject.format = "True/False"
      assert_equal "True/False", subject.format
    end

  end

  class NumberFormatXmlTest < NumberFormatTest
    desc "for generating XML"

    should have_reader :xml
    should_build_xml
    should_build_no_attributes_by_default(Xmlss::Style::Alignment)
  end

end

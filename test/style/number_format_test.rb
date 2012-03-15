require "assert"
require 'enumeration/assert_macros'

require 'xmlss/style/number_format'

module Xmlss::Style
  class NumberFormatTest < Assert::Context
    include Enumeration::AssertMacros

    desc "Xmlss::Style::NumberFormat"
    before { @nf = NumberFormat.new }
    subject { @nf }

    should have_class_method :writer
    should have_accessor :format

    should "know its writer" do
      assert_equal :number_format, subject.class.writer
    end

    should "set attributes at init" do
      nf = NumberFormat.new("General")
      assert_equal "General", nf.format
    end

  end

end

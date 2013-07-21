require "assert"
require 'xmlss/style/number_format'

require 'enumeration/assert_macros'

class Xmlss::Style::NumberFormat

  class UnitTests < Assert::Context
    include Enumeration::AssertMacros

    desc "Xmlss::Style::NumberFormat"
    before { @nf = Xmlss::Style::NumberFormat.new }
    subject { @nf }

    should have_class_method :writer
    should have_accessor :format

    should "know its writer" do
      assert_equal :number_format, subject.class.writer
    end

    should "set attributes at init" do
      nf = Xmlss::Style::NumberFormat.new("General")
      assert_equal "General", nf.format
    end

  end

end

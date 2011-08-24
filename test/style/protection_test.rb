require "assert"
require 'xmlss/style/protection'

module Xmlss::Style

  class ProtectionTest < Assert::Context
    desc "Xmlss::Style::Protection"
    before { @sp = Xmlss::Style::Protection.new }
    subject { @sp }

    should have_instance_methods :protected?
    should have_accessor :protect

    should "set it's defaults" do
      assert_equal false, subject.protected?
    end

    should "set attrs at init time" do
      sp = Xmlss::Style::Protection.new({
        :protect => true
      })
      assert sp.protected?
    end

    should "set attrs after init time" do
      subject.protect = true
      assert subject.protected?
    end

  end

  class ProtectionXmlTest < ProtectionTest
    desc "for generating XML"

    should have_reader :xml
    should_build_node
    should_build_no_attributes_by_default(Xmlss::Style::Alignment)

  end

end

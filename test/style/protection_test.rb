require "assert"

require 'xmlss/style/protection'

module Xmlss::Style

  class ProtectionTest < Assert::Context
    desc "Xmlss::Style::Protection"
    before { @sp = Xmlss::Style::Protection.new }
    subject { @sp }

    should have_class_method :writer
    should have_accessor :protect
    should have_instance_methods :protected?

    should "know its writer" do
      assert_equal :protection, subject.class.writer
    end

    should "set it's defaults" do
      assert_equal false, subject.protected?
    end

    should "set attrs at init time" do
      sp = Xmlss::Style::Protection.new(true)
      assert sp.protected?
    end

    should "set attrs after init time" do
      subject.protect = true
      assert subject.protected?
    end

  end

end

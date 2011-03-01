require "test/helper"
require 'xmlss/style/protection'

class Xmlss::Style::ProtectionTest < Test::Unit::TestCase

  context "Xmlss::Style::Protection" do
    subject { Xmlss::Style::Protection.new }

    should_have_instance_methods :protected?
    should_have_accessor :protect

    should "set it's defaults" do
      assert_equal false, subject.protected?
    end

    context "that sets attributes at init" do
      subject do
        Xmlss::Style::Protection.new({
          :protect => true
        })
      end

      should "should set them correctly" do
        assert subject.protected?
      end
    end

    context "that sets attributes after init" do
      before do
        subject.protect = true
      end

      should "should set them correctly" do
        assert subject.protected?
      end
    end

  end

end

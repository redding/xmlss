require 'rubygems'
require 'test_belt'
require 'test/env'

class Test::Unit::TestCase

  class << self

    def should_build_node
      should_have_instance_methods :build_node
      should "build it's node" do
        assert_nothing_raised do
          ::Nokogiri::XML::Builder.new do |builder|
            subject.build_node(builder)
          end
        end
      end
    end

    def should_build_no_attributes_by_default(klass)
      context "by default" do
        subject{ klass.new }

        should "have no element attributes" do
          assert_equal({}, subject.send(:build_attributes))
        end
      end
    end

  end

end
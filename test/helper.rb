# this file is automatically required in when you require 'assert' in your tests
# put test helpers here

# add root dir to the load path
$LOAD_PATH.unshift(File.expand_path("../..", __FILE__))

require 'xmlss'

class Assert::Context

  class << self

    def should_build_xml
      should have_instance_methods :build_xml
      should "build it's xml" do
        assert_nothing_raised { subject.build_xml }
      end
    end

    def should_build_no_attributes_by_default(klass)
      should "have no element attributes" do
        xmlthing = klass.new
        assert_equal({}, xmlthing.send(:build_attributes))
      end
    end

    def should_have_style(klass)
      should have_accessor :style_id
      should have_reader :style_i_d

      should "set the style default" do
        assert_equal nil, subject.style_id
      end

      should "provide aliases for style_id" do
        c = klass.new({:style_id => :poo})
        assert_equal :poo, c.style_id
        assert_equal :poo, c.style_i_d
      end
    end

  end

end

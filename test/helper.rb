# this file is automatically required in when you require 'assert' in your tests
# put test helpers here

# add root dir to the load path
$LOAD_PATH.unshift(File.expand_path("../..", __FILE__))

class Assert::Context

  def self.be_styled
    called_from = caller.first
    Assert::Macro.new("have style attributes") do
      should have_accessor :style_id

      should "set the style default" do
        assert_equal nil, subject.class.new.style_id
      end
    end
  end

end

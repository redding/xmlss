# this file is automatically required in when you require 'assert' in your tests
# put test helpers here

# add root dir to the load path
$LOAD_PATH.unshift(File.expand_path("../..", __FILE__))

class Assert::Context

  class << self

    def be_styled
      called_from = caller.first
      Assert::Macro.new("have style attributes") do
        should have_accessor :style_id
        should have_reader :style_i_d

        should "set the style default" do
          assert_equal nil, subject.class.new.style_id
        end

        should "provide aliases for style_id" do
          c = subject.class.new({:style_id => :poo})
          assert_equal :poo, c.style_id
          assert_equal :poo, c.style_i_d
        end
      end
    end

  end

end
